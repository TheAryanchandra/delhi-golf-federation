import 'package:delhi_golf_federation/model/worldofgolf_model.dart';
import 'package:dio/dio.dart';

class WorldOfGolfRepository {
  final Dio _dio = Dio();

  final String baseUrl = "https://admin.delhigolf.org/api/master/world-of-golf";
  final String apiKey = "065A0566-4ACA-4C5B-9789-9B4992AC40F3";

  Future<WorldOfGolfResponse> fetchWorldOfGolf(WorldOfGolfPayload payload) async {
    try {
      print("📤 Sending request to: $baseUrl");
      print("🧾 Payload: ${payload.toJson()}");

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

      print("📥 Response received with status code: ${response.statusCode}");
      print("📦 Response body: ${response.data}");

      if (response.statusCode == 200) {
        final result = WorldOfGolfResponse.fromJson(response.data);
        print("✅ Parsed successfully — ${result.items.length} venues found.");
        print("🗂️ Current Page: ${result.page} / ${result.totalPage}");
        return result;
      } else {
        print("❌ Failed with status: ${response.statusCode}");
        throw Exception("Failed to load World of Golf data");
      }
    } catch (e) {
      print("💥 Error fetching World of Golf data: $e");
      throw Exception("Error fetching World of Golf data: $e");
    }
  }
}
