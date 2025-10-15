import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:delhi_golf_federation/database/shared_preferences.dart';
import 'package:delhi_golf_federation/model/leaderboardscreen_model.dart';

class LeaderboardScreenRepository {
  final Dio _dio = Dio();
  final String baseUrl =
      "https://admin.delhigolf.org/api/account/leaderboard-details?Action=GetUpcomingEvents";

  Future<LeaderboardScreenModel> fetchLeaderboardScreen({required int page}) async {
    final token = await SharedPreferencesHelper.getUserToken();

    final payload = {
      "Id": "",
      "RefNo": "",
      "Region": "",
      "RowRefNo": "",
      "Cmp_Code": "",
      "EntryType": "Manual",
      "UserId": "",
      "UserId2": "",
      "RoleId": 0,
      "Page": page,
      "TotalPage": 0,
      "PageSize": 5,
      "_dt": null,
      "ds": null,
      "_DataRow": null
    };

    try {
      final response = await _dio.post(
        baseUrl,
        data: jsonEncode(payload),
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
            "Content-Type": "application/json",
          },
        ),
      );

      if (response.statusCode == 200) {
        return LeaderboardScreenModel.fromJson(response.data);
      } else {
        throw Exception("Failed to load leaderboard: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error fetching leaderboard: $e");
    }
  }
}
