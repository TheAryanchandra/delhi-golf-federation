import 'package:delhi_golf_federation/model/eventregistermodel.dart';
import 'package:equatable/equatable.dart';


abstract class EventRegistrationState extends Equatable {
  const EventRegistrationState();

  @override
  List<Object?> get props => [];
}

class EventRegistrationInitial extends EventRegistrationState {}

class EventRegistrationLoading extends EventRegistrationState {}

class EventRegistrationSuccess extends EventRegistrationState {
  final EventRegistrationResponse response;

  const EventRegistrationSuccess(this.response);

  @override
  List<Object?> get props => [response];
}

class EventRegistrationFailure extends EventRegistrationState {
  final String error;

  const EventRegistrationFailure(this.error);

  @override
  List<Object?> get props => [error];
}
