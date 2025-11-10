import 'package:delhi_golf_federation/model/worldofgolf_model.dart';
import 'package:equatable/equatable.dart';


abstract class WorldOfGolfState extends Equatable {
  @override
  List<Object?> get props => [];
}

class WorldOfGolfInitial extends WorldOfGolfState {}

class WorldOfGolfLoading extends WorldOfGolfState {}

class WorldOfGolfLoaded extends WorldOfGolfState {
  final List<WorldOfGolfItem> items;
  final int currentPage;
  final int totalPage;

  WorldOfGolfLoaded({
    required this.items,
    required this.currentPage,
    required this.totalPage,
  });

  @override
  List<Object?> get props => [items, currentPage, totalPage];
}

class WorldOfGolfError extends WorldOfGolfState {
  final String message;

  WorldOfGolfError(this.message);

  @override
  List<Object?> get props => [message];
}
