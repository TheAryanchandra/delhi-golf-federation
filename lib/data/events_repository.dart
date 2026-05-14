import 'package:delhi_golf_federation/config/network/web_constant.dart';
import 'package:delhi_golf_federation/config/network/dio_client.dart';
import 'package:delhi_golf_federation/model/eventmodel.dart';

class EventsRepository {
  Future<EventsResponse> fetchEvents({String? action, int page = 1}) async {
    final String url = '$eventsEndpoint${action != null ? '?Action=$action' : ''}';

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
      final response = await DioClient().post(
        url,
        data: requestData,
      );

      return EventsResponse.fromJson(response.data);
    } catch (e) {
      return EventsResponse(
        status: false,
        message: 'No data available',
        response: null,
      );
    }
  }
}
