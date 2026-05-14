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
      final basicAuth = 'Basic ${base64Encode(utf8.encode('$key:$secret'))}';

      final response = await _dio.get(
        'https://api.razorpay.com/v1/payments/$paymentId',
        options: Options(headers: {'Authorization': basicAuth}),
      );

      if (response.statusCode == 200) {
        return RazorpayPaymentDetails.fromJson(response.data);
      } else {
        throw Exception('Failed to fetch payment details');
      }
    } catch (e) {
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

    try {
      final response = await _dio.post(
        url,
        data: paymentRequest.toJson(),
        options: Options(headers: headers),
      );

      return PaymentResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(
        'Final Payment API Error: ${e.response?.data ?? e.message}',
      );
    } catch (e) {
      throw Exception('Unexpected Error: $e');
    }
  }
}
