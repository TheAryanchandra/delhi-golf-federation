import 'package:flutter_bloc/flutter_bloc.dart';
import 'event_event.dart';
import 'event_state.dart';
import 'package:delhi_golf_federation/data/events_repository.dart';

class EventsBloc extends Bloc<EventsEvent, EventsState> {
  final EventsRepository repository;
  final int itemsPerPage = 5;

  EventsBloc(this.repository) : super(EventsInitial()) {
    on<FetchEvents>(_onFetchEvents);
  }

  Future<void> _onFetchEvents(FetchEvents event, Emitter<EventsState> emit) async {
    emit(EventsLoading());
    try {
      final action = event.upcoming == true ? "GetUpcomingEvents" : "GetPastEvents";
      final page = event.page ?? 1;

      final response = await repository.fetchEvents(action: action, page: page);

      // Use exact field names from your model
      final events = response.response?.dt ?? [];
      final totalRecords = response.response?.totalPage ?? events.length;

      final totalPages = events.isEmpty ? 1 : (totalRecords / itemsPerPage).ceil();

      emit(EventsLoaded(
        events: events,
        totalPages: totalPages,
        currentPage: page,
      ));
    } catch (e) {
      emit(EventsError(message: e.toString()));
    }
  }
}
