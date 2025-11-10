import 'package:equatable/equatable.dart';

abstract class WorldOfGolfEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchWorldOfGolfEvent extends WorldOfGolfEvent {
  final String action;
  final String entryType;
  final int page;

  FetchWorldOfGolfEvent({
    required this.action,
    required this.entryType,
    this.page = 1,
  });

  @override
  List<Object?> get props => [action, entryType, page];
}
