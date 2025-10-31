import 'package:delhi_golf_federation/model/paymentmodel.dart';
import 'package:dio/dio.dart';

class PaymentRepository {
  final Dio _dio = Dio();

  Future<PaymentResponse> createPayment({
    required PaymentRequest request,
    required String cmpCode,
  }) async {
    const String url =
        'https://admin.delhigolf.org/api/account/registration-payment?Action=INSERT';

    final headers = {
      'Content-Type': 'application/json',
      'api-key': '065A0566-4ACA-4C5B-9789-9B4992AC40F3',
      'a_Id_UserId': cmpCode, // ✅ Send cmp_code here
    };

    // ✅ Log what we're sending
    print('\n========= 🧾 PAYMENT REQUEST START =========');
    print('➡️ API URL: $url');
    print('➡️ Headers: $headers');
    print('➡️ Request Body: ${request.toJson()}');
    print('============================================\n');

    try {
      final response = await _dio.post(
        url,
        data: request.toJson(),
        options: Options(headers: headers),
      );

      // ✅ Log what we received
      print('\n========= ✅ PAYMENT RESPONSE RECEIVED =========');
      print('🔹 Status Code: ${response.statusCode}');
      print('🔹 Response Data: ${response.data}');
      print('=================================================\n');

      return PaymentResponse.fromJson(response.data);
    } on DioException catch (e) {
      print('\n❌ DioException occurred during payment API call!');
      print('🔸 Error Message: ${e.message}');
      print('🔸 Response Data: ${e.response?.data}');
      print('🔸 Status Code: ${e.response?.statusCode}');
      print('=================================================\n');
      throw Exception('Payment API Error: ${e.response?.data ?? e.message}');
    } catch (e) {
      print('\n🚨 Unexpected Exception occurred!');
      print('🔸 Error: $e');
      print('=================================================\n');
      throw Exception('Unexpected Error: $e');
    }
  }

  Future<PaymentResponse> confirmPayment({
    required PaymentRequest request,
    required String cmpCode,
  }) async {
    const String url =
        'https://admin.delhigolf.org/api/account/registration-payment?Action=INSERT';

    final headers = {
      'Content-Type': 'application/json',
      'api-key': '065A0566-4ACA-4C5B-9789-9B4992AC40F3',
      'a_Id_UserId': cmpCode,
    };

    print('\n========= 🧾 CONFIRM PAYMENT REQUEST START =========');
    print('➡️ API URL: $url');
    print('➡️ Headers: $headers');
    print('➡️ Request Body: ${request.toJson()}');
    print('============================================\n');

    try {
      final response = await _dio.post(
        url,
        data: request.toJson(),
        options: Options(headers: headers),
      );

      print('\n========= ✅ CONFIRM PAYMENT RESPONSE RECEIVED =========');
      print('🔹 Status Code: ${response.statusCode}');
      print('🔹 Response Data: ${response.data}');
      print('=================================================\n');

      return PaymentResponse.fromJson(response.data);
    } on DioException catch (e) {
      print('\n❌ DioException occurred during confirm payment API call!');
      print('🔸 Error Message: ${e.message}');
      print('🔸 Response Data: ${e.response?.data}');
      print('🔸 Status Code: ${e.response?.statusCode}');
      print('=================================================\n');
      throw Exception(
        'Confirm Payment API Error: ${e.response?.data ?? e.message}',
      );
    } catch (e) {
      print('\n🚨 Unexpected Exception occurred!');
      print('🔸 Error: $e');
      print('=================================================\n');
      throw Exception('Unexpected Error: $e');
    }
  }
}
