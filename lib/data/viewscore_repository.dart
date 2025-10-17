import 'package:delhi_golf_federation/database/shared_preferences.dart';
import 'package:dio/dio.dart';
import 'package:delhi_golf_federation/model/viewscore_model.dart';

class ViewScoreRepository {
  final Dio _dio = Dio();
  static const String _baseUrl =
      "https://admin.delhigolf.org/api/account/view-score";

  Future<ViewScoreResponse> fetchViewScore(String date, String eventRefNo) async {
    final String? token = await SharedPreferencesHelper.getUserToken();

    // Build full query URL
    final String finalUrl = "$_baseUrl?Date=$date&Action=score";

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

    // Print final request info
    print("🔹 Final URL: $finalUrl");
    print("🔹 Headers: ${{"Authorization": "Bearer $token"}}");
    print("🔹 Request Body: $requestBody");

    try {
      final response = await _dio.post(
        finalUrl,
        data: requestBody,
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );

      print("✅ Response Status: ${response.statusCode}");
      print("✅ Response Data: ${response.data}");

      return ViewScoreResponse.fromJson(response.data);
    } catch (e) {
      print("❌ Error: $e");
      throw Exception("Failed to fetch view score: $e");
    }
  }
}
