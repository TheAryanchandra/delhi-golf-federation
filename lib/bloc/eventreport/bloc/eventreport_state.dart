import 'package:delhi_golf_federation/model/eventreportmodel.dart';
import 'package:equatable/equatable.dart';


abstract class EventReportState extends Equatable {
  const EventReportState();

  @override
  List<Object?> get props => [];
}

class EventReportInitial extends EventReportState {}

class EventReportLoading extends EventReportState {}

class EventReportLoaded extends EventReportState {
  final EventReportResponse response;

  const EventReportLoaded(this.response);

  @override
  List<Object?> get props => [response];
}

class EventReportError extends EventReportState {
  final String message;

  const EventReportError(this.message);

  @override
  List<Object?> get props => [message];
}
