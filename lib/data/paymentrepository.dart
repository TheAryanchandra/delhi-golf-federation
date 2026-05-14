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
      'a_Id_UserId': cmpCode,
    };

    try {
      final response = await _dio.post(
        url,
        data: request.toJson(),
        options: Options(headers: headers),
      );

      return PaymentResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception('Payment API Error: ${e.response?.data ?? e.message}');
    } catch (e) {
      throw Exception('Unexpected Error: $e');
    }
  }

  Future<PaymentResponse> confirmPayment({
    required PaymentRequest request,
    required String cmpCode,
  }) async {
    const String url =
        'https://admin.delhigolf.org/api/account/registration-payment?Action=UPDATE';

    final headers = {
      'Content-Type': 'application/json',
      'api-key': '065A0566-4ACA-4C5B-9789-9B4992AC40F3',
      'a_Id_UserId': cmpCode,
    };

    try {
      final response = await _dio.post(
        url,
        data: request.toJson(),
        options: Options(headers: headers),
      );

      return PaymentResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(
        'Confirm Payment API Error: ${e.response?.data ?? e.message}',
      );
    } catch (e) {
      throw Exception('Unexpected Error: $e');
    }
  }
}
