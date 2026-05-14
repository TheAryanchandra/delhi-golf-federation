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

class RegistrationRepository {
  final String apiKey = "065A0566-4ACA-4C5B-9789-9B4992AC40F3";

  Future<RegistrationResponseModel> registerUser(
    RegistrationRequestModel requestModel,
  ) async {
    final response = await http.post(
      Uri.parse(registrationEndpoint), 
      headers: {
        "Content-Type": headersJson, 
        "api-key": apiKey, 
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


class LoginRepository {
  Future<LoginResponse> login({
    required String email,
    required String password,
  }) async {
    try {
      final uri = Uri.parse(loginEndpoint);

      final headers = {
        "Content-Type": "application/json",
        "api-key": "065A0566-4ACA-4C5B-9789-9B4992AC40F3",
        "a_Id_UserId": email,
        "Passowrd_User": password,
      };


      final response = await http.post(uri, headers: headers);



      if (response.statusCode == 200 || response.statusCode == 402) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);

        if (response.statusCode == 402) {
          final message =
              jsonResponse['message']?.toString() ?? 'Membership expired';
          return LoginResponse.fromJson(
            jsonResponse,
            statusCode: response.statusCode,
          );
        }
        final String? token = jsonResponse["response"] as String?;
        if (token != null && token.isNotEmpty) {
          await SharedPreferencesHelper.setUserToken(token);
          await SharedPreferencesHelper.setLoggedIn(true);
          await SharedPreferencesHelper.setUserEmail(email);

        }
        return LoginResponse.fromJson(
          jsonResponse,
          statusCode: response.statusCode,
        );
      } else {
        throw Exception("Failed to login: ${response.statusCode}");
      }
    } catch (e) {
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
      return LogoutModel(
        id: 0,
        bigId: 0,
        status: true,
        response: "Token already expired",
      );
    }

    final uri = Uri.parse(logoutEndpoint);

    final headers = {
      "Accept": headersJson,
      "Authorization": "Bearer $token",
    };



    final response = await http.get(uri, headers: headers);



    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final logoutModel = LogoutModel.fromJson(data);

      await SharedPreferencesHelper.clearUserData();

      return logoutModel;
    } else {
      throw Exception("Logout failed: ${response.statusCode}");
    }
  }
}


class IndustryRepository {
  Future<IndustryResponse> fetchIndustries() async {
    try {
      final response = await http.get(
        Uri.parse(industryEndpoint),
        headers: {"Content-Type": headersJson, "api-key": apiKey},
      );



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

      final Map<String, dynamic> jsonResponse = response.data;
      final data = RefreshTokenModel.fromJson(jsonResponse);

      if (response.statusCode == 200 &&
          data.status &&
          data.response.isNotEmpty) {
        await SharedPreferencesHelper.setUserToken(data.response);
      }

      return data;
    } on DioException catch (e) {
      if (e.response != null && e.response!.data != null) {
        final Map<String, dynamic> jsonResponse = e.response!.data;
        final data = RefreshTokenModel.fromJson(jsonResponse);
        return data;
      }
      throw Exception('Token refresh failed: ${e.message}');
    } catch (e) {
      throw Exception('Token refresh failed: $e');
    }
  }
}
