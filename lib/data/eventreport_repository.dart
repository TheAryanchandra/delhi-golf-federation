import 'package:delhi_golf_federation/config/network/dio_client.dart';
import 'package:delhi_golf_federation/config/network/web_constant.dart';
import 'package:delhi_golf_federation/model/eventreportmodel.dart';

class EventReportRepository {
  Future<EventReportResponse> fetchEvents({
    required EventReportRequest request,
    required bool isCurrent,
  }) async {
    final action = isCurrent ? "GetUpcomingEvents" : "getpastevents";
    
    final response = await DioClient().post(
      "$eventReportEndpoint?Action=$action",
      data: request.toJson(),
    );

    return EventReportResponse.fromJson(response.data);
  }
}
