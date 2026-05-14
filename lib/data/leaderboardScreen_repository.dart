import 'package:delhi_golf_federation/config/network/dio_client.dart';
import 'package:delhi_golf_federation/config/network/web_constant.dart';
import 'package:delhi_golf_federation/model/leaderboardscreen_model.dart';

class LeaderboardScreenRepository {
  Future<LeaderboardScreenModel> fetchLeaderboardScreen({required int page}) async {
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
      final response = await DioClient().post(
        "$leaderboardDetailsEndpoint?Action=GetUpcomingEvents",
        data: payload,
      );

      return LeaderboardScreenModel.fromJson(response.data);
    } catch (e) {
      throw Exception("Error fetching leaderboard: $e");
    }
  }
}
