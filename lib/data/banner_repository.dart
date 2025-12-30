import 'package:dio/dio.dart';
import '../model/banner_model.dart';


class BannerRepository {
  final Dio _dio = Dio();

  static const String baseUrl =
      "https://admin.delhigolf.org/api/master/get-banner-details";

  static const String apiKey =
      "065A0566-4ACA-4C5B-9789-9B4992AC40F3";

  Future<BannerResponse> fetchBanners(BannerPayload payload) async {
    try {
      final response = await _dio.post(
        baseUrl,
        data: payload.toJson(),
        options: Options(
          headers: {
            "api-key": apiKey,
            "Content-Type": "application/json",
          },
        ),
      );

      if (response.statusCode == 200) {
        return BannerResponse.fromJson(response.data);
      } else {
        throw Exception("Failed to load banners");
      }
    } catch (e) {
      throw Exception("Banner API Error: $e");
    }
  }
}
