import 'package:delhi_golf_federation/config/network/dio_client.dart';
import 'package:delhi_golf_federation/config/network/web_constant.dart';
import 'package:delhi_golf_federation/model/scorecard_model.dart';

class EventScoreRepository {
  Future<EventScoreResponse> getEventScores(EventScoreRequest request) async {
    try {
      final response = await DioClient().post(
        "$getEventsScoresEndpoint?Action=getScore",
        data: request.toJson(),
      );

      return EventScoreResponse.fromJson(response.data);
    } catch (e) {
      throw Exception("Error fetching event scores: $e");
    }
  }
}
