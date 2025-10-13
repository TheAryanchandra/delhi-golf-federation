import 'dart:convert';
import 'package:delhi_golf_federation/database/shared_preferences.dart';
import 'package:delhi_golf_federation/model/eventreportmodel.dart';
import 'package:http/http.dart' as http;

class EventReportRepository {
  final String baseUrl = "https://admin.delhigolf.org/api/account/score-events";

  /// Fetch Current or Past Scorecards based on action
  Future<EventReportResponse> fetchEvents({
    required EventReportRequest request,
    required bool isCurrent,
  }) async {
    try {
      final token = await SharedPreferencesHelper.getUserToken();
      final action = isCurrent ? "GetUpcomingEvents" : "getpastevents";
      final uri = Uri.parse("$baseUrl?Action=$action");

      print("🔹 [EventReportRepository] Fetching events...");
      print("➡️ Endpoint: $uri");
      print("🪪 Token (first 10 chars): ${token?.substring(0, token!.length > 10 ? 10 : token.length)}...");
      print("📦 Request Payload: ${jsonEncode(request.toJson())}");

      final response = await http.post(
        uri,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode(request.toJson()),
      );

      print("📡 Status Code: ${response.statusCode}");
      print("🧾 Raw Response Body:\n${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print("✅ Parsed Response: ${data.runtimeType}");
        return EventReportResponse.fromJson(data);
      } else {
        print("❌ Failed to load events (code: ${response.statusCode})");
        throw Exception("Failed to load events (code: ${response.statusCode})");
      }
    } catch (e, stack) {
      print("🚨 Error in fetchEvents(): $e");
      print("📍 Stack Trace: $stack");
      throw Exception("Error fetching event report: $e");
    }
  }
}
