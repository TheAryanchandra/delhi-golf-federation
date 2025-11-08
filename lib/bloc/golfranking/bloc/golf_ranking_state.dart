
import 'package:delhi_golf_federation/model/golf_ranking_model.dart';
import 'package:equatable/equatable.dart';

abstract class GolfRankingState extends Equatable {
  @override
  List<Object?> get props => [];
}

class GolfRankingInitial extends GolfRankingState {}

class GolfRankingLoading extends GolfRankingState {}

class GolfRankingLoaded extends GolfRankingState {
  final GolfRankingResponse response;
  GolfRankingLoaded(this.response);

  @override
  List<Object?> get props => [response];
}

class GolfRankingError extends GolfRankingState {
  final String message;
  GolfRankingError(this.message);

  @override
  List<Object?> get props => [message];
}
