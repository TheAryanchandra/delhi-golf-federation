import 'package:delhi_golf_federation/config/network/dio_client.dart';
import 'package:delhi_golf_federation/config/network/web_constant.dart';
import 'package:delhi_golf_federation/model/viewscore_model.dart';

class ViewScoreRepository {
  Future<ViewScoreResponse> fetchViewScore(String date, String eventRefNo) async {
    // Build full query URL
    final String finalUrl = "$viewScoreEndpoint?Date=$date&Action=score";

    // Request body
    final Map<String, dynamic> requestBody = {
      "Id": "",
      "RefNo": eventRefNo,
      "Region": "",
      "RowRefNo": "",
      "Cmp_Code": "",
      "EntryType": "",
      "UserId": "",
      "UserId2": "",
      "RoleId": null,
      "Page": null,
      "TotalPage": null,
      "PageSize": null,
      "_dt": null,
      "ds": null,
      "_DataRow": null,
    };

    try {
      final response = await DioClient().post(
        finalUrl,
        data: requestBody,
      );

      return ViewScoreResponse.fromJson(response.data);
    } catch (e) {
      throw Exception("Failed to fetch view score: $e");
    }
  }
}
