import 'package:delhi_golf_federation/model/eventdetailsmodel.dart';
import 'package:equatable/equatable.dart';


abstract class EventDetailsState extends Equatable {
  const EventDetailsState();

  @override
  List<Object?> get props => [];
}

class EventDetailsInitial extends EventDetailsState {}

class EventDetailsLoading extends EventDetailsState {}

class EventDetailsLoaded extends EventDetailsState {
  final EventDetailsModel eventDetails;

  const EventDetailsLoaded(this.eventDetails);

  @override
  List<Object?> get props => [eventDetails];
}

class EventDetailsError extends EventDetailsState {
  final String message;

  const EventDetailsError(this.message);

  @override
  List<Object?> get props => [message];
}
