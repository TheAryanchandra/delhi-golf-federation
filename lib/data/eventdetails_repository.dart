import 'package:delhi_golf_federation/config/network/dio_client.dart';
import 'package:delhi_golf_federation/config/network/web_constant.dart';
import 'package:delhi_golf_federation/model/eventdetailsmodel.dart';


class EventDetailsRepository {
  Future<EventDetailsModel> fetchEventDetails(String refNo) async {
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

    final response = await DioClient().post(
      '$viewEventEndpoint?Action=signleDetails',
      data: payload,
    );

    return EventDetailsModel.fromJson(response.data);
  }
}
