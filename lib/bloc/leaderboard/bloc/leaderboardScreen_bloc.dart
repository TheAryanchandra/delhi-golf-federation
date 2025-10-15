import 'package:delhi_golf_federation/bloc/leaderboard/bloc/leaderboardScreen_event.dart';
import 'package:delhi_golf_federation/bloc/leaderboard/bloc/leaderboardScreen_state.dart';
import 'package:delhi_golf_federation/data/leaderboardScreen_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class LeaderboardScreenBloc
    extends Bloc<LeaderboardScreenEvent, LeaderboardScreenState> {
  final LeaderboardScreenRepository repository;

  LeaderboardScreenBloc(this.repository) : super(LeaderboardScreenInitial()) {
    on<FetchLeaderboardScreenEvent>((event, emit) async {
      emit(LeaderboardScreenLoading());
      try {
        final data =
            await repository.fetchLeaderboardScreen(page: event.page);
        emit(LeaderboardScreenLoaded(data));
      } catch (e) {
        emit(LeaderboardScreenError(e.toString()));
      }
    });
  }
}
