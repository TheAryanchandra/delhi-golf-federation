import 'package:delhi_golf_federation/bloc/viewscore/bloc/viewscore_event.dart';
import 'package:delhi_golf_federation/bloc/viewscore/bloc/viewscore_state.dart';
import 'package:delhi_golf_federation/data/viewscore_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class ViewScoreBloc extends Bloc<ViewScoreEvent, ViewScoreState> {
  final ViewScoreRepository repository;

  ViewScoreBloc(this.repository) : super(ViewScoreInitial()) {
    on<FetchViewScoreEvent>(_onFetchViewScore);
  }

  Future<void> _onFetchViewScore(
      FetchViewScoreEvent event, Emitter<ViewScoreState> emit) async {
    emit(ViewScoreLoading());
    try {
      final response = await repository.fetchViewScore(event.date, event.eventRefNo);
      emit(ViewScoreLoaded(response));
    } catch (e) {
      emit(ViewScoreError(e.toString()));
    }
  }
}
