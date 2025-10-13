// lib/data/event_score_repository.dart
import 'dart:convert';
import 'package:delhi_golf_federation/database/shared_preferences.dart';
import 'package:delhi_golf_federation/model/scorecard_model.dart';

import 'package:http/http.dart' as http;

class EventScoreRepository {
  final String baseUrl =
      "https://admin.delhigolf.org/api/account/get-events-scores";

  Future<EventScoreResponse> getEventScores(EventScoreRequest request) async {
    try {
      print("Fetching event scores...");
      print(request.toJson());
      print(baseUrl);
      print(request.toJson());
      final token = await SharedPreferencesHelper.getUserToken();
      final uri = Uri.parse("$baseUrl?Action=getScore");

      final response = await http.post(
        uri,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode(request.toJson()),
      );
      print(response.body);
      print(response.statusCode);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return EventScoreResponse.fromJson(data);
      } else {
        throw Exception(
          "Failed to fetch event scores (status code: ${response.statusCode})",
        );
      }
    } catch (e) {
      throw Exception("Error fetching event scores: $e");
    }
  }
}
