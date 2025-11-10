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
    print("🔹 EventSearchBloc: FetchUpcomingEvents triggered");
    emit(EventSearchLoading());
    try {
      final response = await repository.fetchUpcomingEvents();
      print("🔹 FetchUpcomingEvents response: ${response?.eventList?.map((e) => e.name).toList()}");

      if (response != null && response.eventList != null && response.eventList!.isNotEmpty) {
        emit(EventSearchLoaded(response.eventList!));
        print("✅ FetchUpcomingEvents: Loaded ${response.eventList!.length} events");
      } else {
        emit(const EventSearchError("No events found"));
        print("⚠️ FetchUpcomingEvents: No events found");
      }
    } catch (e) {
      emit(EventSearchError("Failed to load events: $e"));
      print("❌ FetchUpcomingEvents error: $e");
    }
  }

  Future<void> _onFetchEventSearch(
      FetchEventSearch event, Emitter<EventSearchState> emit) async {
    print("🔹 EventSearchBloc: FetchEventSearch triggered with query: '${event.query}'");

    if (event.query.isEmpty) {
      emit(EventSearchInitial());
      print("🔹 FetchEventSearch: Query empty, emitting initial state");
      return;
    }

    emit(EventSearchLoading());
    try {
      final response = await repository.fetchUpcomingEvents(searchQuery: event.query);
      print("🔹 FetchEventSearch response: ${response?.eventList?.map((e) => e.name).toList()}");

      if (response != null && response.eventList != null && response.eventList!.isNotEmpty) {
        emit(EventSearchLoaded(response.eventList!));
        print("✅ FetchEventSearch: Loaded ${response.eventList!.length} events");
      } else {
        emit(const EventSearchError("No events found"));
        print("⚠️ FetchEventSearch: No events found");
      }
    } catch (e) {
      emit(EventSearchError("Failed to search events: $e"));
      print("❌ FetchEventSearch error: $e");
    }
  }
}
