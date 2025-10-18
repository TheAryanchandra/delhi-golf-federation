import 'package:equatable/equatable.dart';

abstract class EventDetailsEvent extends Equatable {
  const EventDetailsEvent();

  @override
  List<Object?> get props => [];
}

class FetchEventDetailsEvent extends EventDetailsEvent {
  final String refNo;

  const FetchEventDetailsEvent(this.refNo);

  @override
  List<Object?> get props => [refNo];
}
