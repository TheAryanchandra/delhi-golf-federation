import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:delhi_golf_federation/config/network/dio_client.dart';

import 'package:delhi_golf_federation/database/shared_preferences.dart';
import 'package:delhi_golf_federation/model/eventmodel.dart';


class EventsRepository {
  Future<EventsResponse> fetchEvents({String? action, int page = 1}) async {
    final url = Uri.parse(
      'https://admin.delhigolf.org/api/account/events${action != null ? '?Action=$action' : ''}',
    );

    final Map<String, dynamic> requestData = {
      "Id": null,
      "RefNo": null,
      "Region": null,
      "RowRefNo": null,
      "Cmp_Code": null,
      "EntryType": "Manual",
      "UserId": null,
      "UserId2": null,
      "RoleId": null,
      "Page": page,
      "TotalPage": null,
      "PageSize": 5,
      "_dt": null,
      "ds": null,
      "_DataRow": null,
    };

    try {
      final token = await SharedPreferencesHelper.getUserToken();

      print("URL: $url");
      print("Body: ${jsonEncode(requestData)}");

      final response = await DioClient().dio.post(
        url.toString(),
        data: requestData,
        options: Options(
          headers: {
            "Accept": "application/json",
            "Content-Type": "application/json",
            // "api-key": "065A0566-4ACA-4C5B-9789-9B4992AC40F3",
            if (token != null && token.isNotEmpty)
              "Authorization": "Bearer $token",
          },
        ),
      );

      print("Status: ${response.statusCode}");
      print("Response: ${response.data}");

      if (response.statusCode == 200) {
        final data = response.data;
        return EventsResponse.fromJson(data);
      } else {
        throw Exception('Failed to load events: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching events: $e');
    }
  }
}
