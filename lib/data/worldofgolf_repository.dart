import 'package:delhi_golf_federation/config/network/dio_client.dart';
import 'package:delhi_golf_federation/config/network/web_constant.dart';
import 'package:delhi_golf_federation/model/worldofgolf_model.dart';

class WorldOfGolfRepository {
  Future<WorldOfGolfResponse> fetchWorldOfGolf(WorldOfGolfPayload payload) async {
    try {
      final response = await DioClient().post(
        worldOfGolfEndpoint,
        data: payload.toJson(),
      );

      return WorldOfGolfResponse.fromJson(response.data);
    } catch (e) {
      throw Exception("Error fetching World of Golf data: $e");
    }
  }
}
