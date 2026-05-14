import 'package:delhi_golf_federation/config/network/dio_client.dart';
import '../config/network/web_constant.dart';
import '../model/banner_model.dart';


class BannerRepository {
  Future<BannerResponse> fetchBanners(BannerPayload payload) async {
    final response = await DioClient().post(
      bannerEndpoint,
      data: payload.toJson(),
    );

    return BannerResponse.fromJson(response.data);
  }
}
