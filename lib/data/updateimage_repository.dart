import 'dart:convert';
import 'dart:io';
import 'package:delhi_golf_federation/config/network/dio_client.dart';
import 'package:delhi_golf_federation/config/network/web_constant.dart';
import 'package:delhi_golf_federation/model/updatedprofile_model.dart';
import 'package:dio/dio.dart';

class UpdateProfileRepository {
  Future<Response> updateProfile(UpdateProfileModel model, File? imageFile) async {
    FormData formData = FormData.fromMap({
      'jsonForm': jsonEncode(model.toJson()),
      if (imageFile != null)
        'img': await MultipartFile.fromFile(
          imageFile.path,
          filename: imageFile.path.split('/').last,
        ),
    });

    final response = await DioClient().post(
      updateProfileEndpoint,
      data: formData,
      options: Options(
        headers: {
          'Content-Type': 'multipart/form-data',
        },
      ),
    );

    return response;
  }
}
