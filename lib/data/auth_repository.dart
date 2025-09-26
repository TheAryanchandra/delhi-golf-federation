import 'dart:convert';
import 'package:delhi_golf_federation/model/registermodel.dart';
import 'package:http/http.dart' as http;

// register repository
class RegistrationRepository {
  final String baseUrl = "https://admin.delhigolf.org/api/account/registration";

  // replace this with your actual key
  final String apiKey = "065A0566-4ACA-4C5B-9789-9B4992AC40F3";  

  Future<RegistrationResponseModel> registerUser(
      RegistrationRequestModel requestModel) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {
        "Content-Type": "application/json",
        "api-key": apiKey, // or use "x-api-key" depending on backend requirement
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
