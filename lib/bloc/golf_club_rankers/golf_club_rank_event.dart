import 'package:delhi_golf_federation/model/golfranking_clubgolfers_model.dart';
import 'package:equatable/equatable.dart';


abstract class GolfClubGolfersRankingEvent extends Equatable {
  const GolfClubGolfersRankingEvent();

  @override
  List<Object?> get props => [];
}

class FetchGolfClubGolfersRankingEvent extends GolfClubGolfersRankingEvent {
  final GolfClubGolfersRankingRequest request;

  const FetchGolfClubGolfersRankingEvent({required this.request});

  @override
  List<Object?> get props => [request];
}

