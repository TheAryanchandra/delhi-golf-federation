import 'package:delhi_golf_federation/bloc/event_search/bloc/event_search_event.dart';
import 'package:delhi_golf_federation/bloc/event_search/bloc/event_search_state.dart';
import 'package:delhi_golf_federation/data/event_search_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EventSearchBloc extends Bloc<EventSearchEvent, EventSearchState> {
  final EventSearchRepository repository;

  EventSearchBloc(this.repository) : super(EventSearchInitial()) {
    on<FetchUpcomingEvents>(_onFetchUpcomingEvents);
    on<FetchEventSearch>(_onFetchEventSearch);
  }

  Future<void> _onFetchUpcomingEvents(
      FetchUpcomingEvents event, Emitter<EventSearchState> emit) async {
    emit(EventSearchLoading());
    try {
      final response = await repository.fetchUpcomingEvents();


      if (response != null && response.eventList != null && response.eventList!.isNotEmpty) {
        emit(EventSearchLoaded(response.eventList!));

      } else {
        emit(const EventSearchError("No events found"));
      }
    } catch (e) {
      emit(EventSearchError("Failed to load events: $e"));
    }
  }

  Future<void> _onFetchEventSearch(
      FetchEventSearch event, Emitter<EventSearchState> emit) async {


    if (event.query.isEmpty) {
      emit(EventSearchInitial());

      return;
    }

    emit(EventSearchLoading());
    try {
      final response = await repository.fetchUpcomingEvents(searchQuery: event.query);


      if (response != null && response.eventList != null && response.eventList!.isNotEmpty) {
        emit(EventSearchLoaded(response.eventList!));

      } else {
        emit(const EventSearchError("No events found"));

      }
    } catch (e) {
      emit(EventSearchError("Failed to search events: $e"));
    }
  }
}
