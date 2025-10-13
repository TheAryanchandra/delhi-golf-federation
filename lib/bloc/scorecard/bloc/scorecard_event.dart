// lib/bloc/eventscore/eventscore_event.dart
import 'package:delhi_golf_federation/model/scorecard_model.dart';
import 'package:equatable/equatable.dart';


abstract class EventScoreEvent extends Equatable {
  const EventScoreEvent();

  @override
  List<Object?> get props => [];
}

class FetchEventScore extends EventScoreEvent {
  final EventScoreRequest request;

  const FetchEventScore({required this.request});

  @override
  List<Object?> get props => [request];
}
