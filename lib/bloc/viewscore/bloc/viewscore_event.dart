import 'package:equatable/equatable.dart';

abstract class ViewScoreEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchViewScoreEvent extends ViewScoreEvent {
  final String date;
  final String eventRefNo;

  FetchViewScoreEvent({required this.date, required this.eventRefNo});

  @override
  List<Object?> get props => [date, eventRefNo];
}
