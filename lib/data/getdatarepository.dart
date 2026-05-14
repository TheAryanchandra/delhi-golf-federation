import 'package:delhi_golf_federation/config/network/web_constant.dart';
import 'package:delhi_golf_federation/config/network/dio_client.dart';
import 'package:delhi_golf_federation/database/shared_preferences.dart';
import 'package:delhi_golf_federation/model/getdatamodel.dart';
import 'package:dio/dio.dart';

class AuthRepository {
  Future<UserDataModel> fetchUserData() async {
    // Retrieve stored email
    final email = await SharedPreferencesHelper.getUserEmail();
    if (email == null || email.isEmpty) {
      throw Exception("Email not found in SharedPreferences");
    }

    final response = await DioClient().get(
      getUserEndpoint,
      queryParameters: {
        'mode': 'getDataWithEmail',
      },
      options: Options(
        headers: {
          'a_Id_UserId': email, // 👈 send email here in header
        },
      ),
    );

    if (response.data['status'] == true) {
      return UserDataModel.fromJson(response.data);
    } else {
      throw Exception(response.data['message'] ?? 'Failed to fetch user data');
    }
  }
}
