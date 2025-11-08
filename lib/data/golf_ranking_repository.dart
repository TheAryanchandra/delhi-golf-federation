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
      print("🟢 [GolfRankingRepository] Sending Request:");
      print("➡️ URL: https://admin.delhigolf.org/api/master/golf-ranking-list");
      print("➡️ Headers: ${_dio.options.headers}");
      print("➡️ Request Body: ${request.toJson()}");

      final response = await _dio.post(
        "master/golf-ranking-list",
        data: request.toJson(),
      );

      // 🔹 Print raw response details
      print("\n🟣 [GolfRankingRepository] Received Response:");
      print("⬅️ Status Code: ${response.statusCode}");
      print("⬅️ Data: ${response.data}");

      if (response.statusCode == 200) {
        print("✅ Response parsed successfully\n");
        return GolfRankingResponse.fromJson(response.data);
      } else {
        print("❌ Error: Unexpected status code ${response.statusCode}\n");
        return null;
      }
    } catch (e) {
      // 🔹 Print exception
      print("\n🔴 [GolfRankingRepository] Exception while fetching golf rankings:");
      print(e);
      return null;
    }
  }
}
