
import 'package:delhi_golf_federation/model/eventmodel.dart';
import 'package:equatable/equatable.dart';

abstract class EventsState extends Equatable {
  @override
  List<Object?> get props => [];
}

class EventsInitial extends EventsState {}

class EventsLoading extends EventsState {}

class EventsLoaded extends EventsState {
  final List<EventModel>? events;
  final int? totalPages;
  final int? currentPage;

  EventsLoaded({this.events, this.totalPages, this.currentPage});

  @override
  List<Object?> get props => [events ?? [], totalPages , currentPage ?? 1];
}

class EventsError extends EventsState {
  final String? message;

  EventsError({this.message});

  @override
  List<Object?> get props => [message ?? ''];
}
