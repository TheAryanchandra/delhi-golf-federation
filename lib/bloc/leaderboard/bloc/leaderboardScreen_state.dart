import 'package:equatable/equatable.dart';
import 'package:delhi_golf_federation/model/leaderboardscreen_model.dart';

abstract class LeaderboardScreenState extends Equatable {
  const LeaderboardScreenState();

  @override
  List<Object?> get props => [];
}

class LeaderboardScreenInitial extends LeaderboardScreenState {}

class LeaderboardScreenLoading extends LeaderboardScreenState {}

class LeaderboardScreenLoaded extends LeaderboardScreenState {
  final LeaderboardScreenModel leaderboardData;
  const LeaderboardScreenLoaded(this.leaderboardData);

  @override
  List<Object?> get props => [leaderboardData];
}

class LeaderboardScreenError extends LeaderboardScreenState {
  final String message;
  const LeaderboardScreenError(this.message);

  @override
  List<Object?> get props => [message];
}
