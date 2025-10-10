import 'dart:async';
import 'dart:collection';
import 'package:dio/dio.dart';
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
    print('🔧 [DioClient] Initializing with baseUrl: $baseUrl');
    dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        contentType: 'application/json',
      ),
    );

    dio.interceptors.add(
      QueuedInterceptorsWrapper(
        // ─────── attach current token to every request ───────
        onRequest: (options, handler) async {
          print(
            '🚀 [DioClient] onRequest interceptor triggered for: ${options.path}',
          );
          final token = await SharedPreferencesHelper.getUserToken();

          // Attach Authorization header only if we have a valid token
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
            print(
              '🔑 [DioClient] Token attached: ${token.substring(0, token.length > 20 ? 20 : token.length)}...',
            );
          } else {
            options.headers.remove('Authorization');
            print('⚠️ [DioClient] No token available');
          }

          // Always keep connection alive
          options.headers['Connection'] = 'keep-alive';

          // Ensure API key is present unless explicitly overridden
          options.headers.putIfAbsent('api-key', () => apiKey);

          print('📋 [DioClient] Request headers: ${options.headers}');
          return handler.next(options);
        },

        // ─────── pass normal responses straight through ───────
        onResponse: (response, handler) {
          print(
            '✅ [DioClient] onResponse: ${response.statusCode} for ${response.requestOptions.path}',
          );
          return handler.next(response);
        },

        // ─────── handle errors ───────
        onError: (error, handler) async {
          print('❌ [DioClient] onError interceptor triggered');
          print('❌ [DioClient] Error type: ${error.type}');
          print('❌ [DioClient] Status code: ${error.response?.statusCode}');
          print('❌ [DioClient] Path: ${error.requestOptions.path}');
          print('❌ [DioClient] Error message: ${error.message}');

          final status = error.response?.statusCode;
          final isAuthError = status == 401 || status == 403;
          final alreadyRetried = error.requestOptions.extra['retried'] == true;

          print(
            '🔍 [DioClient] isAuthError: $isAuthError, alreadyRetried: $alreadyRetried',
          );

          // ---------- AUTH FLOW ----------
          if (isAuthError && !alreadyRetried) {
            print(
              '⚠️ [DioClient] Auth error ($status) on ${error.requestOptions.path}, scheduling token refresh.',
            );
            // 1️⃣ park this request
            final completer = Completer<Response>();
            _queue.add(_QueuedRequest(error.requestOptions, completer));
            print(
              '📥 [DioClient] Request queued. Queue length: ${_queue.length}',
            );

            // 2️⃣ be sure only ONE refresh runs
            await _refreshLock.synchronized(() async {
              print(
                '🔒 [DioClient] Entered synchronized block, queue length: ${_queue.length}',
              );
              // if this is the first waiter → actually refresh
              if (_queue.length == 1) {
                print(
                  '🔁 [DioClient] ${_queue.length} request in queue – triggering refresh.',
                );
                try {
                  print(
                    '🔄 [DioClient] Calling RefreshTokenRepository.refreshToken()...',
                  );
                  final newTokenModel = await _auth.refreshToken();
                  print(
                    '📦 [DioClient] Refresh result: status=${newTokenModel.status}, token=${newTokenModel.response}',
                  );
                  if (newTokenModel.status &&
                      newTokenModel.response.isNotEmpty) {
                    // Token persistence is handled inside RefreshTokenRepository
                    print(
                      '🔄 [DioClient] Token refresh completed successfully in dio_client',
                    );
                  } else {
                    print(
                      '⚠️ [DioClient] Token refresh returned false status or empty token',
                    );
                  }
                } catch (refreshError) {
                  print(
                    '❌ [DioClient] Token refresh failed with error: $refreshError',
                  );
                } finally {
                  // 3️⃣ replay every queued request (success or failure)
                  print(
                    '🔁 [DioClient] Starting to replay ${_queue.length} queued requests',
                  );
                  while (_queue.isNotEmpty) {
                    final queued = _queue.removeFirst();
                    print(
                      '🔁 [DioClient] Retrying ${queued.options.path} with fresh token.',
                    );
                    try {
                      final newResp = await _retryWithFreshToken(
                        queued.options,
                      );
                      print(
                        '✅ [DioClient] Retry success for ${queued.options.path}',
                      );
                      queued.completer.complete(newResp);
                    } catch (err) {
                      print(
                        '❌ [DioClient] Retry failed for ${queued.options.path}: $err',
                      );
                      queued.completer.completeError(err);
                    }
                  }
                  print('✅ [DioClient] All queued requests replayed');
                }
              } else {
                print(
                  '⏭️ [DioClient] Not first in queue, skipping refresh (another request is handling it)',
                );
              }
            });

            // 4️⃣ when this specific request's retry completes, resolve it
            print('⏳ [DioClient] Waiting for completer to resolve...');
            final result = await completer.future;
            print('✅ [DioClient] Completer resolved, returning response');
            return handler.resolve(result);
          }

          // ---------- OTHER ERRORS ----------
          print(
            '⚠️ [DioClient] Not an auth error or already retried, handling as regular error',
          );
          switch (error.type) {
            case DioExceptionType.connectionTimeout:
            case DioExceptionType.sendTimeout:
            case DioExceptionType.receiveTimeout:
              print('⏱️ [DioClient] Timeout error');
              return handler.reject(
                DioException(
                  requestOptions: error.requestOptions,
                  error: Exception('Request timed out.'),
                  type: DioExceptionType.unknown,
                ),
              );

            case DioExceptionType.unknown:
              print('🌐 [DioClient] Unknown/Network error');
              return handler.reject(
                DioException(
                  requestOptions: error.requestOptions,
                  error: Exception('No internet connection.'),
                  type: DioExceptionType.unknown,
                ),
              );

            case DioExceptionType.badResponse:
              print('📛 [DioClient] Bad response error');
              return handler.reject(
                DioException(
                  requestOptions: error.requestOptions,
                  error: Exception('Bad response: $status'),
                  type: DioExceptionType.unknown,
                ),
              );

            default:
              print('❓ [DioClient] Other error type');
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
    print('✅ [DioClient] Initialization complete with interceptors added');

    // Start periodic token refresh
    _startPeriodicRefresh();
  }

  // ────────────────�� PERIODIC REFRESH ─────────────────────
  void _startPeriodicRefresh() {
    print('⏰ [DioClient] Starting periodic token refresh (every 5 minutes)');

    // Refresh immediately on init if logged in
    _performTokenRefresh();

    // Then refresh every 5 minutes
    _refreshTimer = Timer.periodic(const Duration(minutes: 5), (timer) {
      _performTokenRefresh();
    });
  }

  Future<void> _performTokenRefresh() async {
    try {
      final isLoggedIn = await SharedPreferencesHelper.isLoggedIn();
      final token = await SharedPreferencesHelper.getUserToken();

      if (!isLoggedIn || token == null || token.isEmpty) {
        print(
          '⏭️ [DioClient] Skipping refresh - user not logged in or no token',
        );
        return;
      }

      print('🔄 [DioClient] Performing periodic token refresh...');
      final newTokenModel = await _auth.refreshToken();

      print(
        '📦 [DioClient] Periodic refresh result: status=${newTokenModel.status}, token=${newTokenModel.response}',
      );

      if (newTokenModel.status && newTokenModel.response.isNotEmpty) {
        print(
          '🔄 [DioClient] Token refresh completed successfully in dio_client',
        );
      } else {
        print(
          '⚠️ [DioClient] Periodic refresh returned false status or empty token',
        );
      }
    } catch (e) {
      print('❌ [DioClient] Periodic token refresh failed: $e');
    }
  }

  // Stop the periodic refresh timer
  void dispose() {
    _refreshTimer?.cancel();
    print('🛑 [DioClient] Periodic refresh timer cancelled');
  }

  // ───────────────── HELPERS ────────────────────
  Future<Response<dynamic>> _retryWithFreshToken(
    RequestOptions original,
  ) async {
    print('🧪 [DioClient] _retryWithFreshToken called for: ${original.path}');
    final newToken = await SharedPreferencesHelper.getUserToken();
    if (newToken != null && newToken.isNotEmpty) {
      print(
        '🔑 [DioClient] Retrieved new token for retry: ${newToken.substring(0, newToken.length > 20 ? 20 : newToken.length)}...',
      );
    } else {
      print('⚠️ [DioClient] No new token available for retry');
    }

    // Start from original headers and update auth + api-key
    final headers = Map<String, dynamic>.from(original.headers);
    if (newToken != null && newToken.isNotEmpty) {
      headers['Authorization'] = 'Bearer $newToken';
      print('✅ [DioClient] Authorization header updated with new token');
    } else {
      headers.remove('Authorization');
      print(
        '⚠️ [DioClient] No new token available, removing Authorization header',
      );
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
    print(
      '🧪 [DioClient] Retrying ${cloned.path} with updated Authorization header.',
    );
    print('📋 [DioClient] Retry headers: ${cloned.headers}');
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
      throw Exception(
        'Dio error: ${e.response?.statusCode ?? 'unknown'} - ${e.message}',
      );
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
    } catch (e) {
      print('❌ [DioClient] POST error: $e');
      rethrow;
    }
  }

  // ───────────────── TEST HELPER ────────────────────
  /// Temporarily corrupts the token to test refresh flow
  Future<void> testTokenRefresh() async {
    print('🧪 [DioClient] TEST: Corrupting token to trigger 401...');
    await SharedPreferencesHelper.setUserToken('invalid_token_for_testing');
    print(
      '🧪 [DioClient] TEST: Token corrupted. Next API call should trigger refresh.',
    );
  }

  // Add new method for global logout
  Future<void> handleAuthFailure() async {
    print('🔐 [DioClient] Handling auth failure - logging out user');
    await SharedPreferencesHelper.clearUserData();
    // Notify auth state listeners
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
