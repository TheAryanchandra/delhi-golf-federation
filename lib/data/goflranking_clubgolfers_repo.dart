import 'package:delhi_golf_federation/database/shared_preferences.dart';
import 'package:delhi_golf_federation/model/golfranking_clubgolfers_model.dart';
import 'package:dio/dio.dart';

class GolfClubGolfersRankingRepository {
  final Dio _dio = Dio();

  Future<GolfClubGolfersRankingResponse> fetchGolfClubGolfersRanking({
    required GolfClubGolfersRankingRequest request,
  }) async {
    const String url =
        'https://admin.delhigolf.org/api/account/delhi-golf-ranking';

    try {
      // 🔹 Get token from SharedPreferences
      final String? token = await SharedPreferencesHelper.getUserToken();

      if (token == null || token.isEmpty) {
        throw Exception("No token found in SharedPreferences");
      }

      // 🔹 Log what we're sending


      // 🔹 Send POST request
      final response = await _dio.post(
        url,
        data: request.toJson(),
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );

      // 🔹 Log response details


      if (response.statusCode == 200) {
        return GolfClubGolfersRankingResponse.fromJson(response.data);
      } else {
        throw Exception(response.data.toString());
      }
    } catch (e, stackTrace) {
      // 🔴 Log full error and stack trace for better debugging


      throw Exception("Error fetching golf club golfers ranking: $e");
    }
  }
}
