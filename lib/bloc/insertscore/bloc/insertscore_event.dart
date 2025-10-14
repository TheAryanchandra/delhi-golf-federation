import 'package:delhi_golf_federation/model/insertscore_model.dart';
import 'package:equatable/equatable.dart';


abstract class LeaderboardEvent extends Equatable {
  const LeaderboardEvent();

  @override
  List<Object?> get props => [];
}

class SubmitLeaderboard extends LeaderboardEvent {
  final LeaderboardRequest request;

  const SubmitLeaderboard({required this.request});

  @override
  List<Object?> get props => [request];
}
