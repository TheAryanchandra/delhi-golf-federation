import 'dart:convert';
import 'package:delhi_golf_federation/config/network/web_constant.dart';
import 'package:delhi_golf_federation/database/shared_preferences.dart';
import 'package:delhi_golf_federation/model/login_model.dart';
import 'package:delhi_golf_federation/model/logout_model.dart';
import 'package:delhi_golf_federation/model/registermodel.dart';
import 'package:http/http.dart' as http;

// register repository
class RegistrationRepository {
  // replace this with your actual key
  final String apiKey = "065A0566-4ACA-4C5B-9789-9B4992AC40F3";

  Future<RegistrationResponseModel> registerUser(
    RegistrationRequestModel requestModel,
  ) async {
    final response = await http.post(
      Uri.parse(registrationEndpoint), // use constant from webconstant
      headers: {
        "Content-Type": headersJson, // also use constant for content type
        "api-key": apiKey, // or "x-api-key" depending on backend
      },
      body: jsonEncode(requestModel.toJson()),
    );

    if (response.statusCode == 200) {
      return RegistrationResponseModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Failed to register user: ${response.body}");
    }
  }
}

// login repository

class LoginRepository {
  Future<LoginResponse> login({
    required String email,
    required String password,
  }) async {
    try {
      final uri = Uri.parse(loginEndpoint);

      final headers = {
        // "Accept": "*/*",
        "Content-Type": "application/json",
        "api-key": "065A0566-4ACA-4C5B-9789-9B4992AC40F3",
        "a_Id_UserId": email,
        "Passowrd_User": password,
      };

      print("🔹 Login API Request:");
      print("URL: $uri");
      print("Headers: $headers");

      final response = await http.post(uri, headers: headers);

      print("🔹 Login API Response:");
      print("Status Code: ${response.statusCode}");
      print("Body: ${response.body}");

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);

        // ✅ Extract token from response
        final String? token = jsonResponse["response"] as String?;
        if (token != null && token.isNotEmpty) {
          await SharedPreferencesHelper.setUserToken(token);
          await SharedPreferencesHelper.setLoggedIn(true);
          print("✅ Token saved in SharedPreferences: $token");
        }
        return LoginResponse.fromJson(jsonResponse);
      } else {
        throw Exception("Failed to login: ${response.statusCode}");
      }
    } catch (e) {
      // Ensure auth status is reset on failure
      await SharedPreferencesHelper.setLoggedIn(false);
      await SharedPreferencesHelper.setUserToken('');
      throw Exception("Login failed: $e");
    }
  }
}

class LogoutRepository {
  Future<LogoutModel> logout() async {
    final token = await SharedPreferencesHelper.getUserToken();

    if (token == null || token.isEmpty) {
      // Already expired or never saved
      return LogoutModel(
        id: 0,
        bigId: 0,
        status: true,
        response: "Token already expired",
      );
    }

    final uri = Uri.parse(logoutEndpoint); // ✅ use constant

    final headers = {
      "Accept": headersJson,
      "Authorization": "Bearer $token",
      // "api-key": apiKey, // ✅ same as login
    };

    print("🔑 Token for logout: $token");
    print("Logout URL: $uri");
    print("Logout Headers: $headers");

    final response = await http.get(uri, headers: headers);

    print("🔹 Logout API Response:");
    print("Status Code: ${response.statusCode}");
    print("Body: ${response.body}");

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final logoutModel = LogoutModel.fromJson(data);

      // Clear user data when status == false (successful logout)
      if (logoutModel.status == false) {
        await SharedPreferencesHelper.clearUserData();
      }

      return logoutModel;
    } else {
      throw Exception("Logout failed: ${response.statusCode}");
    }
  }
}