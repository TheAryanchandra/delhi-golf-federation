// lib/bloc/eventscore/eventscore_state.dart
import 'package:delhi_golf_federation/model/scorecard_model.dart';
import 'package:equatable/equatable.dart';

abstract class EventScoreState extends Equatable {
  const EventScoreState();

  @override
  List<Object?> get props => [];
}

class EventScoreInitial extends EventScoreState {}

class EventScoreLoading extends EventScoreState {}

class EventScoreLoaded extends EventScoreState {
  final EventScoreResponse response;

  const EventScoreLoaded(this.response);

  @override
  List<Object?> get props => [response];
}

class EventScoreError extends EventScoreState {
  final String message;

  const EventScoreError(this.message);

  @override
  List<Object?> get props => [message];
}
