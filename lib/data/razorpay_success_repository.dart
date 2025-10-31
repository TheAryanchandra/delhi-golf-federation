import 'dart:convert';
import 'package:dio/dio.dart';
import '../model/razorpayresponse_model.dart';
import '../model/paymentmodel.dart';

class PaymentAfterSuccess {
  final Dio _dio = Dio();

  Future<RazorpayPaymentDetails> getPaymentDetails({
    required String paymentId,
    required String key,
    required String secret,
  }) async {
    try {
      print('🔑 Razorpay API Call Initialized...');
      print('➡️ Payment ID: $paymentId');
      print('🧩 Using Key: $key');
      print('🧩 Using Secret: $secret');

      // ✅ Create Basic Auth header
      final basicAuth = 'Basic ${base64Encode(utf8.encode('$key:$secret'))}';
      print('🪪 Encoded Auth Header: $basicAuth');

      // ✅ Make GET request to Razorpay
      final response = await _dio.get(
        'https://api.razorpay.com/v1/payments/$paymentId',
        options: Options(headers: {'Authorization': basicAuth}),
      );

      print('📡 API Response Status: ${response.statusCode}');
      print('📦 Full Response Data: ${response.data}');

      if (response.statusCode == 200) {
        final paymentDetails = RazorpayPaymentDetails.fromJson(response.data);
        print('✅ Payment fetched successfully');
        print('💰 Amount: ₹${paymentDetails.amount}');
        print('📋 Status: ${paymentDetails.status}');
        print('📞 Contact: ${paymentDetails.contact}');
        print('✉️ Email: ${paymentDetails.email}');
        print('🏦 Method: ${paymentDetails.method}');
        return paymentDetails;
      } else {
        print('⚠️ Unexpected response status: ${response.statusCode}');
        throw Exception('Failed to fetch payment details');
      }
    } catch (e) {
      print('❌ Error fetching Razorpay payment details: $e');
      throw Exception('Error: $e');
    }
  }

  Future<PaymentResponse> sendFinalPaymentDetails({
    required PaymentRequest paymentRequest,
    required String cmpCode,
  }) async {
    const String url =
        'https://admin.delhigolf.org/api/account/registration-payment?Action=INSERT';

    final headers = {
      'Content-Type': 'application/json',
      'api-key': '065A0566-4ACA-4C5B-9789-9B4992AC40F3',
      'a_Id_UserId': cmpCode,
    };

    print('\n========= 🧾 FINAL PAYMENT REQUEST START =========');
    print('➡️ API URL: $url');
    print('➡️ Headers: $headers');
    print('➡️ Request Body: ${paymentRequest.toJson()}');
    print('============================================\n');

    try {
      final response = await _dio.post(
        url,
        data: paymentRequest.toJson(),
        options: Options(headers: headers),
      );

      print('\n========= ✅ FINAL PAYMENT RESPONSE RECEIVED =========');
      print('🔹 Status Code: ${response.statusCode}');
      print('🔹 Response Data: ${response.data}');
      print('=================================================\n');

      return PaymentResponse.fromJson(response.data);
    } on DioException catch (e) {
      print('\n❌ DioException occurred during final payment API call!');
      print('🔸 Error Message: ${e.message}');
      print('🔸 Response Data: ${e.response?.data}');
      print('🔸 Status Code: ${e.response?.statusCode}');
      print('=================================================\n');
      throw Exception(
        'Final Payment API Error: ${e.response?.data ?? e.message}',
      );
    } catch (e) {
      print('\n🚨 Unexpected Exception occurred!');
      print('🔸 Error: $e');
      print('=================================================\n');
      throw Exception('Unexpected Error: $e');
    }
  }
}
