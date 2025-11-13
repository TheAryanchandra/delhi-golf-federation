import 'package:delhi_golf_federation/model/event_search_mdeol.dart';
import 'package:dio/dio.dart';

class EventSearchRepository {
  final Dio _dio = Dio();

  final String _baseUrl = "https://admin.delhigolf.org/api/master/get-event-name-auto";

  Future<EventSearchResponse?> fetchUpcomingEvents({String searchQuery = ""}) async {
    try {
      final Map<String, dynamic> payload = {
        "Id": searchQuery,
        "RefNo": "",
        "Region": "",
        "RowRefNo": "",
        "Cmp_Code": "",
        "Dates": "",
        "EventRefNo": "",
        "EventRegNo": "",
        "EntryType": "Event",
        "IsActive": "True",
        "FinalSubmit": true,
        "UserId": "",
        "Action": "eventNameLike",
        "UserId2": "",
        "RoleId": 3,
        "Page": 1,
        "TotalPage": 0,
        "PageSize": 100,
        "_dt": null,
        "ds": null,
        "_DataRow": null
      };



      final response = await _dio.post(
        _baseUrl,
        data: payload,
        options: Options(headers: {
          "api-key": "065A0566-4ACA-4C5B-9789-9B4992AC40F3",
          "Content-Type": "application/json",
        }),
      );



      if (response.statusCode == 200 && response.data != null) {
        return EventSearchResponse.fromJson(response.data);
      } else {

        return null;
      }
    } catch (e) {

      return null;
    }
  }
}
