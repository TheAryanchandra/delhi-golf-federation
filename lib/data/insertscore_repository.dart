import 'dart:convert';
import 'package:delhi_golf_federation/database/shared_preferences.dart';
import 'package:delhi_golf_federation/model/insertscore_model.dart';
import 'package:dio/dio.dart';

class LeaderboardRepository {
  static const String _baseUrl =
      "https://admin.delhigolf.org/api/account/insert-leaderboard";

  final Dio _dio = Dio();

  Future<LeaderboardResponse> submitLeaderboard(
    LeaderboardRequest request,
  ) async {
    // Fetch token inside the method
    final token = await SharedPreferencesHelper.getUserToken();

    if (token == null || token.isEmpty) {
      print("User token not found in SharedPreferences!");
      throw Exception("User token not found.");
    }

    try {


      final response = await _dio.post(
        _baseUrl,
        data: jsonEncode(request.toJson()),
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );



      if (response.statusCode == 200) {
        return LeaderboardResponse.fromJson(response.data);
      } else {
        throw Exception('Failed with status code ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'API Error');
    } catch (e) {

      throw Exception('Unexpected Error: $e');
    }
  }
}
