import 'package:delhi_golf_federation/config/network/dio_client.dart';
import 'package:delhi_golf_federation/config/network/web_constant.dart';
import 'package:delhi_golf_federation/model/insertscore_model.dart';

class LeaderboardRepository {
  Future<LeaderboardResponse> submitLeaderboard(
    LeaderboardRequest request,
  ) async {
    try {
      final response = await DioClient().post(
        insertLeaderboardEndpoint,
        data: request.toJson(),
      );

      return LeaderboardResponse.fromJson(response.data);
    } catch (e) {
      throw Exception('Error submitting score: $e');
    }
  }
}
