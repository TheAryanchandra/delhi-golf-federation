import 'package:delhi_golf_federation/model/golfranking_clubgolfers_model.dart';
import 'package:equatable/equatable.dart';


abstract class GolfClubGolfersRankingState extends Equatable {
  const GolfClubGolfersRankingState();

  @override
  List<Object?> get props => [];
}

class GolfClubGolfersRankingInitial extends GolfClubGolfersRankingState {}

class GolfClubGolfersRankingLoading extends GolfClubGolfersRankingState {}

class GolfClubGolfersRankingLoaded extends GolfClubGolfersRankingState {
  final GolfClubGolfersRankingResponse response;

  const GolfClubGolfersRankingLoaded(this.response);

  @override
  List<Object?> get props => [response];
}

class GolfClubGolfersRankingError extends GolfClubGolfersRankingState {
  final String message;

  const GolfClubGolfersRankingError(this.message);

  @override
  List<Object?> get props => [message];
}
