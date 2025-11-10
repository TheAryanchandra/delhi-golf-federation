import 'package:delhi_golf_federation/database/shared_preferences.dart';
import 'package:delhi_golf_federation/model/eventregistermodel.dart';
import 'package:dio/dio.dart';

class EventRegistrationRepository {
  final Dio _dio = Dio(
    BaseOptions(baseUrl: 'https://admin.delhigolf.org/api/'),
  );

  Future<EventRegistrationResponse> registerEvent(EventRegistrationRequest request) async {
    try {
      // 🔐 Get the saved token from SharedPreferences
      final String? token = await SharedPreferencesHelper.getUserToken();

      if (token == null || token.isEmpty) {
        throw Exception('Authorization token not found. Please log in again.');
      }

      final payload = request.toJson();

      print('🔹 Sending Event Registration Request...');
      print('🔹 URL: https://admin.delhigolf.org/api/account/event-registration');
      print('🔹 Headers:');
      print({
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      });
      print('🔹 Payload:');
      print(payload);

      final response = await _dio.post(
        'account/event-registration',
        data: payload,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ),
      );

      print('✅ Response Received:');
      print('🔸 Status Code: ${response.statusCode}');
      print('🔸 Data: ${response.data}');

      if (response.statusCode == 200) {
        final data = response.data;

        // ✅ Handle both string and map response types safely
        if (data is String) {
          // Example: "Payment Done"
          print('⚠️ Response is a string: $data');
          throw Exception(data);
        } else if (data is Map<String, dynamic>) {
          print('🧩 Response is a Map, parsing normally...');
          return EventRegistrationResponse.fromJson(data);
        } else {
          throw Exception('Unexpected response format: ${data.runtimeType}');
        }
      } else {
        throw Exception('Failed with status code: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Event registration failed: $e');
      throw Exception(e.toString());
    }
  }
}
