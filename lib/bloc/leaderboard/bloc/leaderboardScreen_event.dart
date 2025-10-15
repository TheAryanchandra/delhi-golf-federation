import 'package:equatable/equatable.dart';

abstract class LeaderboardScreenEvent extends Equatable {
  const LeaderboardScreenEvent();

  @override
  List<Object> get props => [];
}

class FetchLeaderboardScreenEvent extends LeaderboardScreenEvent {
  final int page;
  const FetchLeaderboardScreenEvent(this.page);

  @override
  List<Object> get props => [page];
}
