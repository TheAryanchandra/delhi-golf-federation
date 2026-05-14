import 'package:delhi_golf_federation/config/network/dio_client.dart';
import 'package:delhi_golf_federation/config/network/web_constant.dart';
import 'package:delhi_golf_federation/model/eventregistermodel.dart';

class EventRegistrationRepository {
  Future<EventRegistrationResponse> registerEvent(EventRegistrationRequest request) async {
    final response = await DioClient().post(
      eventRegistrationEndpoint,
      data: request.toJson(),
    );

    final data = response.data;

    if (data is String) {
      throw Exception(data);
    } else if (data is Map<String, dynamic>) {
      return EventRegistrationResponse.fromJson(data);
    } else {
      throw Exception('Unexpected response format: ${data.runtimeType}');
    }
  }
}
