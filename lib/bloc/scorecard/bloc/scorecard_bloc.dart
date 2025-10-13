// lib/bloc/eventscore/eventscore_bloc.dart
import 'package:delhi_golf_federation/bloc/scorecard/bloc/scorecard_event.dart';
import 'package:delhi_golf_federation/bloc/scorecard/bloc/scorecard_state.dart';
import 'package:delhi_golf_federation/data/scorecard_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EventScoreBloc extends Bloc<EventScoreEvent, EventScoreState> {
  final EventScoreRepository repository;

  EventScoreBloc(this.repository) : super(EventScoreInitial()) {
    on<FetchEventScore>(_onFetchEventScore);
  }

  Future<void> _onFetchEventScore(FetchEventScore event, Emitter<EventScoreState> emit) async {
    emit(EventScoreLoading());
    try {
      final response = await repository.getEventScores(event.request);
      emit(EventScoreLoaded(response));
    } catch (e) {
      emit(EventScoreError(e.toString()));
    }
  }
}
