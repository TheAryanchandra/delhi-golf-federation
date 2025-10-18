import 'package:delhi_golf_federation/database/shared_preferences.dart';
import 'package:delhi_golf_federation/model/eventdetailsmodel.dart';
import 'package:dio/dio.dart';


class EventDetailsRepository {
  final Dio _dio = Dio(BaseOptions(baseUrl: 'https://admin.delhigolf.org/api/account/'));

  Future<EventDetailsModel> fetchEventDetails(String refNo) async {
    final token = await SharedPreferencesHelper.getUserToken();

    final payload = {
      "Id": "",
      "RefNo": refNo,
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
      "_DataRow": null
    };

    try {
      final response = await _dio.post(
        'view-event?Action=signleDetails',
        data: payload,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        return EventDetailsModel.fromJson(response.data);
      } else {
        throw Exception('Failed to fetch event details');
      }
    } catch (e) {
      throw Exception('Error fetching event details: $e');
    }
  }
}
