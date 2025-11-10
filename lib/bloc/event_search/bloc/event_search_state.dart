import 'package:delhi_golf_federation/model/event_search_mdeol.dart';
import 'package:equatable/equatable.dart';


abstract class EventSearchState extends Equatable {
  const EventSearchState();

  @override
  List<Object?> get props => [];
}

class EventSearchInitial extends EventSearchState {}

class EventSearchLoading extends EventSearchState {}

class EventSearchLoaded extends EventSearchState {
  final List<EventSearchModel> events;

  const EventSearchLoaded(this.events);

  @override
  List<Object?> get props => [events];
}

class EventSearchError extends EventSearchState {
  final String message;

  const EventSearchError(this.message);

  @override
  List<Object?> get props => [message];
}
