import 'package:delhi_golf_federation/config/network/web_constant.dart';
import 'package:delhi_golf_federation/config/network/dio_client.dart';
import 'package:delhi_golf_federation/model/golfranking_clubgolfers_model.dart';

class GolfClubGolfersRankingRepository {
  Future<GolfClubGolfersRankingResponse> fetchGolfClubGolfersRanking({
    required GolfClubGolfersRankingRequest request,
  }) async {
    try {
      final response = await DioClient().post(
        delhiGolfRankingEndpoint,
        data: request.toJson(),
      );

      return GolfClubGolfersRankingResponse.fromJson(response.data);
    } catch (e) {
      throw Exception("Error fetching golf club golfers ranking: $e");
    }
  }
}
