import 'package:delhi_golf_federation/model/golf_ranking_model.dart';
import 'package:dio/dio.dart';


class GolfRankingRepository {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: "https://admin.delhigolf.org/api/",
      headers: {
        "Content-Type": "application/json",
        "api-key": "065A0566-4ACA-4C5B-9789-9B4992AC40F3", // ✅ Added API key
      },
    ),
  );

  Future<GolfRankingResponse?> fetchGolfRankingList(
      GolfRankingRequest request) async {
    try {
      final response = await _dio.post(
        "master/golf-ranking-list",
        data: request.toJson(),
      );

      if (response.statusCode == 200) {
        return GolfRankingResponse.fromJson(response.data);
      } else {
        print("Error: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print("Exception while fetching golf rankings: $e");
      return null;
    }
  }
}
