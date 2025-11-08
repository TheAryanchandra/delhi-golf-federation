import 'package:delhi_golf_federation/data/golf_ranking_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'golf_ranking_event.dart';
import 'golf_ranking_state.dart';

class GolfRankingBloc extends Bloc<GolfRankingEvent, GolfRankingState> {
  final GolfRankingRepository repository;

  GolfRankingBloc(this.repository) : super(GolfRankingInitial()) {
    on<FetchGolfRankingEvent>(_onFetchGolfRanking);
  }

  Future<void> _onFetchGolfRanking(
      FetchGolfRankingEvent event, Emitter<GolfRankingState> emit) async {
    emit(GolfRankingLoading());
    try {
      final response = await repository.fetchGolfRankingList(event.request);
      if (response != null && response.status == true) {
        emit(GolfRankingLoaded(response));
      } else {
        emit(GolfRankingError("Failed to load data"));
      }
    } catch (e) {
      emit(GolfRankingError(e.toString()));
    }
  }
}
