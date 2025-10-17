import 'package:equatable/equatable.dart';
import 'package:delhi_golf_federation/model/viewscore_model.dart';

abstract class ViewScoreState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ViewScoreInitial extends ViewScoreState {}

class ViewScoreLoading extends ViewScoreState {}

class ViewScoreLoaded extends ViewScoreState {
  final ViewScoreResponse data;

  ViewScoreLoaded(this.data);

  @override
  List<Object?> get props => [data];
}

class ViewScoreError extends ViewScoreState {
  final String message;

  ViewScoreError(this.message);

  @override
  List<Object?> get props => [message];
}
