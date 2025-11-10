import 'package:equatable/equatable.dart';

abstract class WorldOfGolfEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchWorldOfGolfEvent extends WorldOfGolfEvent {
  final String action;
  final String entryType;
  final String id;
  // 🔹 Added for News (Latest/Past)
  final String? refNo; // <-- add this line
  final int page;

  FetchWorldOfGolfEvent({
    required this.action,
    required this.entryType,
    this.id = "",
    this.page = 1,
    this.refNo,
  });

  @override
  List<Object?> get props => [action, entryType, id, page, refNo];
}
