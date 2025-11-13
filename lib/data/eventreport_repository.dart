import 'dart:convert';
import 'package:delhi_golf_federation/config/network/web_constant.dart';
import 'package:delhi_golf_federation/database/shared_preferences.dart';
import 'package:delhi_golf_federation/model/eventreportmodel.dart';
// <-- import here
import 'package:http/http.dart' as http;

class EventReportRepository {
  /// Fetch Current or Past Scorecards based on action
  Future<EventReportResponse> fetchEvents({
    required EventReportRequest request,
    required bool isCurrent,
  }) async {
    try {
      final token = await SharedPreferencesHelper.getUserToken();
      final action = isCurrent ? "GetUpcomingEvents" : "getpastevents";
      final uri = Uri.parse("$eventReportEndpoint?Action=$action");



      final response = await http.post(
        uri,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode(request.toJson()),
      );



      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        return EventReportResponse.fromJson(data);
      } else {

        throw Exception("Failed to load events (code: ${response.statusCode})");
      }
    } catch (e, stack) {

      throw Exception("Error fetching event report: $e");
    }
  }
}
