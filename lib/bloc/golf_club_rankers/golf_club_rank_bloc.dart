import 'package:delhi_golf_federation/bloc/golf_club_rankers/golf_club_rank_event.dart';
import 'package:delhi_golf_federation/bloc/golf_club_rankers/golf_club_rank_state.dart';
import 'package:delhi_golf_federation/data/goflranking_clubgolfers_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class GolfClubGolfersRankingBloc
    extends Bloc<GolfClubGolfersRankingEvent, GolfClubGolfersRankingState> {
  final GolfClubGolfersRankingRepository repository;

  GolfClubGolfersRankingBloc({required this.repository})
      : super(GolfClubGolfersRankingInitial()) {
    on<FetchGolfClubGolfersRankingEvent>(_onFetchRanking);
  }

  Future<void> _onFetchRanking(FetchGolfClubGolfersRankingEvent event, Emitter<GolfClubGolfersRankingState> emit) async {
    emit(GolfClubGolfersRankingLoading());
    try {
      final response = await repository.fetchGolfClubGolfersRanking(
        request: event.request,
      );
      emit(GolfClubGolfersRankingLoaded(response));
    } catch (e) {
      emit(GolfClubGolfersRankingError(e.toString()));
    }
  }
}
