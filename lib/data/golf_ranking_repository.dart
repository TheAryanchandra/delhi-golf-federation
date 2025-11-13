import 'package:delhi_golf_federation/model/golf_ranking_model.dart';
import 'package:dio/dio.dart';

class GolfRankingRepository {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: "https://admin.delhigolf.org/api/",
      headers: {
        "Content-Type": "application/json",
        "api-key": "065A0566-4ACA-4C5B-9789-9B4992AC40F3",
      },
    ),
  );

  Future<GolfRankingResponse?> fetchGolfRankingList(
      GolfRankingRequest request) async {
    try {
      // 🔹 Print request before sending


      final response = await _dio.post(
        "master/golf-ranking-list",
        data: request.toJson(),
      );

      // 🔹 Print raw response details


      if (response.statusCode == 200) {

        return GolfRankingResponse.fromJson(response.data);
      } else {

        return null;
      }
    } catch (e) {
      // 🔹 Print exception

      return null;
    }
  }
}
