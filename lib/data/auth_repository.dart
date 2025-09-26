import 'dart:convert';
import 'package:delhi_golf_federation/config/network/web_constant.dart';
import 'package:delhi_golf_federation/model/login_model.dart';
import 'package:delhi_golf_federation/model/registermodel.dart';
import 'package:http/http.dart' as http;

// register repository
class RegistrationRepository {
  // replace this with your actual key
  final String apiKey = "065A0566-4ACA-4C5B-9789-9B4992AC40F3";

  Future<RegistrationResponseModel> registerUser(
      RegistrationRequestModel requestModel) async {
    final response = await http.post(
      Uri.parse(registrationEndpoint), // use constant from webconstant
      headers: {
        "Content-Type": headersJson, // also use constant for content type
        "api-key": apiKey,            // or "x-api-key" depending on backend
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
        return LoginResponse.fromJson(jsonResponse);
      } else {
        throw Exception("Failed to login: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Login failed: $e");
    }
  }
}





