import 'package:bloc/bloc.dart';
import 'package:delhi_golf_federation/bloc/insertscore/bloc/insertscore_event.dart';
import 'package:delhi_golf_federation/bloc/insertscore/bloc/insertscore_state.dart';
import 'package:delhi_golf_federation/data/insertscore_repository.dart';


class LeaderboardBloc extends Bloc<LeaderboardEvent, LeaderboardState> {
  final LeaderboardRepository repository;

  LeaderboardBloc({required this.repository}) : super(LeaderboardInitial()) {
    on<SubmitLeaderboard>(_onSubmitLeaderboard);
  }

  Future<void> _onSubmitLeaderboard(
      SubmitLeaderboard event, Emitter<LeaderboardState> emit) async {
    emit(LeaderboardLoading());
    try {
      final response = await repository.submitLeaderboard(event.request);
      emit(LeaderboardSuccess(response));
    } catch (e) {
      emit(LeaderboardError(e.toString()));
    }
  }
}
