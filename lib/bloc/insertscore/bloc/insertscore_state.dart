import 'package:delhi_golf_federation/model/insertscore_model.dart';
import 'package:equatable/equatable.dart';


abstract class LeaderboardState extends Equatable {
  const LeaderboardState();

  @override
  List<Object?> get props => [];
}

class LeaderboardInitial extends LeaderboardState {}

class LeaderboardLoading extends LeaderboardState {}

class LeaderboardSuccess extends LeaderboardState {
  final LeaderboardResponse response;

  const LeaderboardSuccess(this.response);

  @override
  List<Object?> get props => [response];
}

class LeaderboardError extends LeaderboardState {
  final String message;

  const LeaderboardError(this.message);

  @override
  List<Object?> get props => [message];
}
