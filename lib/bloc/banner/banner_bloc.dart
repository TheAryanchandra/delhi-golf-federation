import 'package:delhi_golf_federation/data/banner_repository.dart';
import 'package:delhi_golf_federation/model/banner_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'banner_event.dart';
import 'banner_state.dart';


class BannerBloc extends Bloc<BannerEvent, BannerState> {
  final BannerRepository repository;

  BannerBloc(this.repository) : super(BannerInitial()) {
    on<FetchBanners>(_onFetchBanners);
  }

  Future<void> _onFetchBanners(
    FetchBanners event,
    Emitter<BannerState> emit,
  ) async {
    emit(BannerLoading());
    try {
      final payload = BannerPayload();
      final response = await repository.fetchBanners(payload);
      emit(BannerLoaded(response.banners));
    } catch (e) {
      emit(BannerError(e.toString()));
    }
  }
}
