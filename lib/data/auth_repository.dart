import 'dart:convert';
import 'package:delhi_golf_federation/config/network/web_constant.dart';
import 'package:delhi_golf_federation/database/shared_preferences.dart';
import 'package:delhi_golf_federation/model/industrymodel.dart';
import 'package:delhi_golf_federation/model/login_model.dart';
import 'package:delhi_golf_federation/model/logout_model.dart';
import 'package:delhi_golf_federation/model/refresh_token_model.dart';
import 'package:delhi_golf_federation/model/registermodel.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';

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

      if (response.statusCode == 200 || response.statusCode == 402) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);

        if (response.statusCode == 402) {
          final message =
              jsonResponse['message']?.toString() ?? 'Membership expired';
          return LoginResponse(
            status: false,
            message: message,
            token: null,
            refNo: jsonResponse['RefNo']?.toString(),
            dataList: (jsonResponse['DataList'] as List<dynamic>?)
                ?.map((e) => e.toString())
                .toList(),
            statusCode: response.statusCode,
          );
        }
        final String? token = jsonResponse["response"] as String?;
        if (token != null && token.isNotEmpty) {
          await SharedPreferencesHelper.setUserToken(token);
          await SharedPreferencesHelper.setLoggedIn(true);
          await SharedPreferencesHelper.setUserEmail(email);
          print("✅ Token saved in SharedPreferences: $token");
          print("✅ Email saved in SharedPreferences: $email");
        }
        return LoginResponse.fromJson(
          jsonResponse,
          statusCode: response.statusCode,
        );
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

      // Clear user data on successful logout (statusCode 200)
      await SharedPreferencesHelper.clearUserData();

      return logoutModel;
    } else {
      throw Exception("Logout failed: ${response.statusCode}");
    }
  }
}

// industry repository

class IndustryRepository {
  Future<IndustryResponse> fetchIndustries() async {
    try {
      final response = await http.get(
        Uri.parse(industryEndpoint),
        headers: {"Content-Type": headersJson, "api-key": apiKey},
      );

      print("🟢 API Response Status Code: ${response.statusCode}");
      print("🟢 API Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        return IndustryResponse.fromJson(jsonResponse);
      } else {
        throw Exception(
          "Failed to load industries (status: ${response.statusCode})",
        );
      }
    } catch (e) {
      throw Exception("Error fetching industries: $e");
    }
  }
}

// refresh token

class RefreshTokenRepository {
  final Dio _dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
    ),
  );

  Future<RefreshTokenModel> refreshToken() async {
    final oldToken = await SharedPreferencesHelper.getUserToken();

    try {
      final response = await _dio.post(
        refreshTokenEndpoint,
        options: Options(
          headers: {
            'Authorization': 'Bearer $oldToken',
            'Connection': 'keep-alive',
            'api-key': apiKey,
            'Content-Type': headersJson,
          },
        ),
      );

      print("🟢 Refresh Token API Status Code: ${response.statusCode}");
      print("🟢 Refresh Token API Response: ${response.data}");

      final Map<String, dynamic> jsonResponse = response.data;
      final data = RefreshTokenModel.fromJson(jsonResponse);

      if (response.statusCode == 200 &&
          data.status &&
          data.response.isNotEmpty) {
        await SharedPreferencesHelper.setUserToken(data.response);
        print('🔄 Token refreshed successfully: ${data.response}');
        print('Updated token stored in shared preferences');
      }

      return data;
    } on DioException catch (e) {
      print(
        "🔴 Refresh Token API Error: ${e.response?.statusCode} - ${e.message}",
      );
      if (e.response != null && e.response!.data != null) {
        final Map<String, dynamic> jsonResponse = e.response!.data;
        final data = RefreshTokenModel.fromJson(jsonResponse);
        print("🟢 Parsed error response: ${data.message}");
        return data;
      }
      throw Exception('Token refresh failed: ${e.message}');
    } catch (e) {
      throw Exception('Token refresh failed: $e');
    }
  }
}
