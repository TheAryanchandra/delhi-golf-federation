import 'package:delhi_golf_federation/model/eventreportmodel.dart';
import 'package:equatable/equatable.dart';


abstract class EventReportEvent extends Equatable {
  const EventReportEvent();

  @override
  List<Object?> get props => [];
}

class FetchEventReport extends EventReportEvent {
  final EventReportRequest request;
  final bool isCurrent; // true = Current, false = Past

  const FetchEventReport({required this.request, required this.isCurrent});

  @override
  List<Object?> get props => [request, isCurrent];
}
