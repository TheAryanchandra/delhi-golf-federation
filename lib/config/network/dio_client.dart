import 'dart:async';
import 'dart:collection';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/foundation.dart';
import 'package:delhi_golf_federation/data/auth_repository.dart';
import 'package:delhi_golf_federation/database/shared_preferences.dart';
import 'package:delhi_golf_federation/config/network/web_constant.dart';
import 'package:synchronized/synchronized.dart';

class DioClient {
  // ───────────────── SINGLETON ─────────────────
  static final DioClient _instance = DioClient._internal();
  factory DioClient() => _instance;
  DioClient._internal();

  // ───────────────── DEPENDENCIES ───────────────
  final RefreshTokenRepository _auth = RefreshTokenRepository();

  // ───────────────── FIELDS ─────────────────────
  late final Dio dio;

  // lock + queue to coordinate refresh flow
  final Lock _refreshLock = Lock();
  final Queue<_QueuedRequest> _queue = Queue();

  // Timer for periodic refresh
  Timer? _refreshTimer;

  // ───────────────── INIT ───────────────────────
  Future<void> init({required String baseUrl}) async {
    dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        contentType: 'application/json',
      ),
    );

    // 🔓 Override SSL verification in debug mode
    if (kDebugMode) {
      (dio.httpClientAdapter as IOHttpClientAdapter).onHttpClientCreate =
          (client) {
            client.badCertificateCallback = (cert, host, port) => true;
            return client;
          };
    }

    dio.interceptors.add(
      QueuedInterceptorsWrapper(
        // ─────── attach current token to every request ───────
        onRequest: (options, handler) async {
          final token = await SharedPreferencesHelper.getUserToken();

          // Attach Authorization header only if we have a valid token
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          } else {
            options.headers.remove('Authorization');
          }

          // Always keep connection alive
          options.headers['Connection'] = 'keep-alive';

          // Ensure API key is present unless explicitly overridden
          options.headers.putIfAbsent('api-key', () => apiKey);

          return handler.next(options);
        },

        // ─────── pass normal responses straight through ───────
        onResponse: (response, handler) {
          return handler.next(response);
        },

        // ─────── handle errors ───────
        onError: (error, handler) async {
          final status = error.response?.statusCode;
          final isAuthError = status == 401 || status == 403;
          final alreadyRetried = error.requestOptions.extra['retried'] == true;

          // ---------- AUTH FLOW ----------
          if (isAuthError && !alreadyRetried) {
            // 1️⃣ park this request
            final completer = Completer<Response>();
            _queue.add(_QueuedRequest(error.requestOptions, completer));

            // 2️⃣ be sure only ONE refresh runs
            await _refreshLock.synchronized(() async {
              // if this is the first waiter → actually refresh
              if (_queue.length == 1) {
                try {
                  final newTokenModel = await _auth.refreshToken();

                  if (newTokenModel.message == "Time out re-login") {
                    await handleAuthFailure();
                    // Reject all queued requests since session is expired
                    while (_queue.isNotEmpty) {
                      final queued = _queue.removeFirst();
                      queued.completer.completeError(
                        DioException(
                          requestOptions: queued.options,
                          error: Exception('Session expired'),
                          type: DioExceptionType.unknown,
                        ),
                      );
                    }
                    return; // Don't replay requests
                  }
                  if (newTokenModel.status &&
                      newTokenModel.response.isNotEmpty) {
                    // Token persistence is handled inside RefreshTokenRepository
                  } else {}
                } catch (refreshError) {
                } finally {
                  // 3️⃣ replay every queued request (success or failure)

                  while (_queue.isNotEmpty) {
                    final queued = _queue.removeFirst();

                    try {
                      final newResp = await _retryWithFreshToken(
                        queued.options,
                      );

                      queued.completer.complete(newResp);
                    } catch (err) {
                      queued.completer.completeError(err);
                    }
                  }
                }
              } else {}
            });

            // 4️⃣ when this specific request's retry completes, resolve it

            final result = await completer.future;

            return handler.resolve(result);
          }

          // ---------- OTHER ERRORS ----------

          switch (error.type) {
            case DioExceptionType.connectionTimeout:
            case DioExceptionType.sendTimeout:
            case DioExceptionType.receiveTimeout:
              return handler.reject(
                DioException(
                  requestOptions: error.requestOptions,
                  error: Exception('Request timed out.'),
                  type: DioExceptionType.unknown,
                ),
              );

            case DioExceptionType.unknown:
              return handler.reject(
                DioException(
                  requestOptions: error.requestOptions,
                  error: Exception('No internet connection.'),
                  type: DioExceptionType.unknown,
                ),
              );

            case DioExceptionType.badResponse:
              String message;
              switch (status) {
                case 408:
                  message =
                      'Request Timeout: The server took too long to respond.';
                  break;
                case 400:
                  message = 'Bad Request: The request was malformed.';
                  break;
                case 401:
                  message = 'Unauthorized: Authentication is required.';
                  break;
                case 403:
                  message = 'Forbidden: Access is denied.';
                  break;
                case 404:
                  message = 'Not Found: The requested resource was not found.';
                  break;
                case 500:
                  message =
                      'Internal Server Error: Something went wrong on the server.';
                  break;
                default:
                  message = 'Bad response: $status';
              }
              return handler.reject(
                DioException(
                  requestOptions: error.requestOptions,
                  error: Exception(message),
                  type: DioExceptionType.unknown,
                ),
              );

            default:
              return handler.reject(
                DioException(
                  requestOptions: error.requestOptions,
                  error: Exception('Something went wrong: ${error.message}'),
                  type: DioExceptionType.unknown,
                ),
              );
          }
        },
      ),
    );

    // Start periodic token refresh
    _startPeriodicRefresh();
  }

  // ────────────────�� PERIODIC REFRESH ─────────────────────
  void _startPeriodicRefresh() {
    if (_refreshTimer?.isActive ?? false) {
      return;
    }

    _performTokenRefresh();
    _refreshTimer = Timer.periodic(const Duration(minutes: 5), (timer) {
      _performTokenRefresh();
    });
  }

  Future<void> _performTokenRefresh() async {
    final isLoggedIn = await SharedPreferencesHelper.isLoggedIn();
    final token = await SharedPreferencesHelper.getUserToken();

    if (!isLoggedIn || token == null || token.isEmpty) {
      return;
    }

    int retryCount = 0;
    const int maxRetries = 3;

    while (retryCount < maxRetries) {
      try {
        final newTokenModel = await _auth.refreshToken();

        if (newTokenModel.message == "Time out re-login") {
          await handleAuthFailure();
          return; // Don't retry
        }

        if (newTokenModel.status && newTokenModel.response.isNotEmpty) {
        } else {}
        return; // success, exit
      } catch (e) {
        retryCount++;
        if (retryCount < maxRetries) {
          final delay = Duration(
            seconds: 2 * retryCount,
          ); // exponential backoff

          await Future.delayed(delay);
        } else {}
      }
    }
  }

  // Stop the periodic refresh timer
  void dispose() {
    _refreshTimer?.cancel();
  }

  // ───────────────── HELPERS ────────────────────
  Future<Response<dynamic>> _retryWithFreshToken(
    RequestOptions original,
  ) async {
    final newToken = await SharedPreferencesHelper.getUserToken();
    if (newToken != null && newToken.isNotEmpty) {
    } else {}

    // Start from original headers and update auth + api-key
    final headers = Map<String, dynamic>.from(original.headers);
    if (newToken != null && newToken.isNotEmpty) {
      headers['Authorization'] = 'Bearer $newToken';
    } else {
      headers.remove('Authorization');
    }
    headers.putIfAbsent('api-key', () => apiKey);

    final cloned = RequestOptions(
      path: original.path,
      method: original.method,
      data: original.data,
      queryParameters: original.queryParameters,
      headers: headers,
      extra: {...original.extra, 'retried': true},
    );

    return dio.fetch(cloned);
  }

  // ───────────────── PUBLIC GET HELPER ────────────────────
  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await dio.get(
        path,
        queryParameters: queryParameters,
        options: options,
      );
      return response;
    } on DioException catch (e) {
      throw handleError(e);
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  // ───────────────── PUBLIC POST HELPER ────────────────────
  Future<Response> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
      return response;
    } on DioException catch (e) {
      throw handleError(e);
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  // ───────────────── ERROR HANDLER ────────────────────
  Exception handleError(DioException error) {
    final status = error.response?.statusCode;
    String message;

    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        message = 'Request timed out. Please check your connection.';
        break;
      case DioExceptionType.connectionError:
        message = 'No internet connection.';
        break;
      case DioExceptionType.badResponse:
        switch (status) {
          case 400:
            message = 'Bad Request: The server could not understand the request.';
            break;
          case 401:
            message = 'Unauthorized: Please login again.';
            break;
          case 403:
            message = 'Forbidden: Access is denied.';
            break;
          case 404:
            message = 'Not Found: The requested resource was not found.';
            break;
          case 500:
            message = 'Internal Server Error: Something went wrong on the server.';
            break;
          default:
            message = error.response?.data?['message'] ?? 'Error: $status';
        }
        break;
      default:
        message = 'Something went wrong. Please try again.';
    }
    return Exception(message);
  }

  // ───────────────── TEST HELPER ────────────────────
  /// Temporarily corrupts the token to test refresh flow
  Future<void> testTokenRefresh() async {
    await SharedPreferencesHelper.setUserToken('invalid_token_for_testing');
  }

  // Add new method for global logout
  Future<void> handleAuthFailure() async {
    dispose(); // 🛑 Stop periodic refresh timer
    await SharedPreferencesHelper.clearUserData();
    authFailureController.add(true);
  }

  // Add stream controller for auth failures
  final StreamController<bool> authFailureController =
      StreamController<bool>.broadcast();
}

// ──────────────────────── QUEUED REQUEST HOLDER ────────────────────────
class _QueuedRequest {
  final RequestOptions options;
  final Completer<Response<dynamic>> completer;
  _QueuedRequest(this.options, this.completer);
}
