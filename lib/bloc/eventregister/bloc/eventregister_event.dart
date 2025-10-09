import 'package:delhi_golf_federation/model/eventregistermodel.dart';
import 'package:equatable/equatable.dart';


abstract class EventRegistrationEvent extends Equatable {
  const EventRegistrationEvent();

  @override
  List<Object?> get props => [];
}

class SubmitEventRegistration extends EventRegistrationEvent {
  final EventRegistrationRequest request;

  const SubmitEventRegistration(this.request);

  @override
  List<Object?> get props => [request];
}
