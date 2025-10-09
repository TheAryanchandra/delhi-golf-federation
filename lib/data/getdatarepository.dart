import 'package:delhi_golf_federation/config/network/dio_client.dart';
import 'package:delhi_golf_federation/database/shared_preferences.dart';
import 'package:delhi_golf_federation/model/getdatamodel.dart';
import 'package:dio/dio.dart';

class AuthRepository {
  final DioClient _dioClient = DioClient();

  // API key constant
  static const String _apiKey = '065A0566-4ACA-4C5B-9789-9B4992AC40F3';

  Future<UserDataModel> fetchUserData() async {
    print('Fetching user data...');
    print('API Key: $_apiKey');

    // Retrieve stored email
    final email = await SharedPreferencesHelper.getUserEmail();
    if (email == null || email.isEmpty) {
      throw Exception("Email not found in SharedPreferences");
    }
    print('Retrieved Email from SharedPreferences: $email');

    try {
      // Send both api-key and email in headers
      final response = await _dioClient.get(
        'https://admin.delhigolf.org/api/account/get-user',
        queryParameters: {
          'mode': 'getDataWithEmail',
          // 'email': email,
        },
        options: Options(
          headers: {
            'api-key': _apiKey,
            'a_Id_UserId': email, // 👈 send email here in header
            'Accept': 'application/json',
          },
        ),
      );

      print("Response status: ${response.statusCode}");
      print("Response data: ${response.data}");

      if (response.statusCode == 200 && response.data['status'] == true) {
        return UserDataModel.fromJson(response.data);
      } else {
        throw Exception(response.data['message'] ?? 'Failed to fetch user data');
      }
    } on DioException catch (e) {
      throw Exception(
        'Network error: ${e.response?.statusCode ?? 'unknown'} - ${e.message}',
      );
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }
}
