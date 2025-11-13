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

    return response;
  }
}
