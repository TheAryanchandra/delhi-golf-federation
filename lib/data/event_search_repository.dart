import 'package:delhi_golf_federation/config/network/dio_client.dart';
import 'package:delhi_golf_federation/config/network/web_constant.dart';
import 'package:delhi_golf_federation/model/event_search_mdeol.dart';

class EventSearchRepository {
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

      final response = await DioClient().post(
        eventNameAutoEndpoint,
        data: payload,
      );

      if (response.data != null) {
        return EventSearchResponse.fromJson(response.data);
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}
