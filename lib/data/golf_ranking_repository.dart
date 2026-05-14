import 'package:delhi_golf_federation/config/network/dio_client.dart';
import 'package:delhi_golf_federation/config/network/web_constant.dart';
import 'package:delhi_golf_federation/model/golf_ranking_model.dart';

class GolfRankingRepository {
  Future<GolfRankingResponse?> fetchGolfRankingList(
      GolfRankingRequest request) async {
    try {
      final response = await DioClient().post(
        golfRankingListEndpoint,
        data: request.toJson(),
      );

      return GolfRankingResponse.fromJson(response.data);
    } catch (e) {
      return null;
    }
  }
}
