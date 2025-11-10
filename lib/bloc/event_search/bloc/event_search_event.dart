import 'package:equatable/equatable.dart';

abstract class EventSearchEvent extends Equatable {
  const EventSearchEvent();

  @override
  List<Object?> get props => [];
}

class FetchUpcomingEvents extends EventSearchEvent {}

class FetchEventSearch extends EventSearchEvent {
  final String query;

  const FetchEventSearch(this.query);

  @override
  List<Object?> get props => [query];
}
