import 'dart:convert';
import 'dart:io';
import 'package:delhi_golf_federation/database/shared_preferences.dart';
import 'package:delhi_golf_federation/model/updatedprofile_model.dart';
import 'package:dio/dio.dart';

class UpdateProfileRepository {
  final Dio _dio = Dio();
  final String baseUrl = "https://admin.delhigolf.org/api/account/update-profile";

  Future<Response> updateProfile(UpdateProfileModel model, File? imageFile) async {
    final token = await SharedPreferencesHelper.getUserToken();

    // 🔹 Prepare FormData (exactly like Postman)
    FormData formData = FormData.fromMap({
      'jsonForm': jsonEncode(model.toJson()), // ✅ Stringified JSON
      if (imageFile != null)
        'img': await MultipartFile.fromFile(
          imageFile.path,
          filename: imageFile.path.split('/').last, // ✅ attach filename
        ),
    });

    // 🔹 Debug prints
    print("===== API REQUEST =====");
    print("URL: $baseUrl");
    print("Headers: Authorization: Bearer $token");
    print("FormData Fields:");
    formData.fields.forEach((f) => print("  ${f.key}: ${f.value}"));
    print("FormData Files:");
    for (var f in formData.files) {
      print("  ${f.key}: ${f.value.filename}");
    }
    print("=======================");

    // 🔹 Send API Request
    final response = await _dio.post(
      baseUrl,
      data: formData,
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'multipart/form-data',
        },
      ),
    );

    // 🔹 Print Response
    print("===== API RESPONSE =====");
    print("Status Code: ${response.statusCode}");
    print("Response Data: ${response.data}");
    print("========================");

    return response;
  }
}
