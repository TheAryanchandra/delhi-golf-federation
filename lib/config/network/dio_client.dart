import 'dart:async';
import 'dart:collection';

// import 'package:dio/dio.dart';
// import 'package:fonofy_merchant/core/exceptions/app_exceptions.dart';
// import 'package:fonofy_merchant/core/network/web_constants.dart';
// import 'package:fonofy_merchant/data/auth_repository.dart';
// import 'package:fonofy_merchant/database/shared_preferences_helper.dart';
// import 'package:synchronized/synchronized.dart';

class DioClient {
  // ───────────────── SINGLETON ─────────────────
  static final DioClient _instance = DioClient._internal();
  factory DioClient() => _instance;
  DioClient._internal();

  // // ───────────────── DEPENDENCIES ───────────────
  // final AuthDatasource _auth = AuthDatasource();

  // // ───────────────── FIELDS ─────────────────────
  // late final Dio dio;

  // //  lock + queue to coordinate refresh flow
  // final Lock _refreshLock = Lock();
  // final Queue<_QueuedRequest> _queue = Queue();

  // // ───────────────── INIT ───────────────────────
  // Future<void> init() async {
  //   dio = Dio(
  //     BaseOptions(
  //       baseUrl: baseurl,
  //       connectTimeout: const Duration(seconds: 10),
  //       receiveTimeout: const Duration(seconds: 10),
  //       contentType: headers,
  //     ),
  //   );

  //   dio.interceptors.add(
  //     QueuedInterceptorsWrapper(
  //       // ─────── attach current token to every request ───────
  //       onRequest: (options, handler) async {
  //         final token = await SharedPreferencesHelper.getUserToken();
  //         options.headers['Authorization'] = 'Bearer $token';
  //         return handler.next(options);
  //       },

  //       // ─────── pass normal responses straight through ───────
  //       onResponse: (response, handler) => handler.next(response),

  //       // ─────── handle errors ───────
  //       onError: (error, handler) async {
  //         final status = error.response?.statusCode;
  //         final isAuthError = status == 401 || status == 403;
  //         final alreadyRetried = error.requestOptions.extra['retried'] == true;

  //         // ---------- AUTH FLOW ----------
  //         if (isAuthError && !alreadyRetried) {
  //           // 1️⃣ park this request
  //           final completer = Completer<Response>();
  //           _queue.add(_QueuedRequest(error.requestOptions, completer));

  //           // 2️⃣ be sure only ONE refresh runs
  //           await _refreshLock.synchronized(() async {
  //             // if this is the first waiter → actually refresh
  //             if (_queue.length == 1) {
  //               try {
  //                 await _auth.generateToken();
  //                 // await SharedPreferencesHelper.saveUserToken(newToken);
  //               } finally {
  //                 // 3️⃣ replay every queued request (success or failure)
  //                 while (_queue.isNotEmpty) {
  //                   final queued = _queue.removeFirst();
  //                   try {
  //                     final newResp =
  //                         await _retryWithFreshToken(queued.options);
  //                     queued.completer.complete(newResp);
  //                   } catch (err) {
  //                     queued.completer.completeError(err);
  //                   }
  //                 }
  //               }
  //             }
  //           });

  //           // 4️⃣ when this specific request’s retry completes, resolve it
  //           return handler.resolve(await completer.future);
  //         }
}
          // ---------- OTHER ERRORS ----------
//           switch (error.type) {
//             case DioExceptionType.connectionTimeout:
//             case DioExceptionType.sendTimeout:
//             case DioExceptionType.receiveTimeout:
//               return handler.reject(
//                 DioException(
//                   requestOptions: error.requestOptions,
//                   error: RequestTimeOutException('Request timed out.'),
//                   type: DioExceptionType.unknown,
//                 ),
//               );

//             case DioExceptionType.unknown:
//               return handler.reject(
//                 DioException(
//                   requestOptions: error.requestOptions,
//                   error: NoInternetException('No internet connection.'),
//                   type: DioExceptionType.unknown,
//                 ),
//               );

//             case DioExceptionType.badResponse:
//               return handler.reject(
//                 DioException(
//                   requestOptions: error.requestOptions,
//                   error: FetchDataException('Bad response: $status'),
//                   type: DioExceptionType.unknown,
//                 ),
//               );

//             default:
//               return handler.reject(
//                 DioException(
//                   requestOptions: error.requestOptions,
//                   error: FetchDataException(
//                       'Something went wrong: ${error.message}'),
//                   type: DioExceptionType.unknown,
//                 ),
//               );
//           }
//         },
//       ),
//     );
//   }

//   // ───────────────── HELPERS ────────────────────

//   Future<Response<dynamic>> _retryWithFreshToken(
//       RequestOptions original) async {
//     final cloned = RequestOptions(
//       path: original.path,
//       method: original.method,
//       data: original.data,
//       queryParameters: original.queryParameters,
//       headers: {
//         ...original.headers,
//         'Authorization':
//             'Bearer ${await SharedPreferencesHelper.getUserToken()}',
//       },
//       extra: {...original.extra, 'retried': true},
//     );
//     return dio.fetch(cloned);
//   }
// }

// // simple holder for queued request info
// class _QueuedRequest {
//   final RequestOptions options;
//   final Completer<Response<dynamic>> completer;
//   _QueuedRequest(this.options, this.completer);
// 