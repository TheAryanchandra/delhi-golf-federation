
import 'package:delhi_golf_federation/model/golf_ranking_model.dart';
import 'package:equatable/equatable.dart';

abstract class GolfRankingEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchGolfRankingEvent extends GolfRankingEvent {
  final GolfRankingRequest request;
  FetchGolfRankingEvent(this.request);

  @override
  List<Object?> get props => [request];
}
