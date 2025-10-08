import 'package:flutter_bloc/flutter_bloc.dart';
import 'event_event.dart';
import 'event_state.dart';
import 'package:delhi_golf_federation/data/events_repository.dart';

class EventsBloc extends Bloc<EventsEvent, EventsState> {
  final EventsRepository repository;

  EventsBloc(this.repository) : super(EventsInitial()) {
    on<FetchEvents>(_onFetchEvents);
  }

  Future<void> _onFetchEvents(FetchEvents event, Emitter<EventsState> emit) async {
    emit(EventsLoading());
    try {
      final action = event.upcoming == true ? "GetUpcomingEvents" : "GetPastEvents";
      final page = event.page ?? 1;

      final response = await repository.fetchEvents(action: action, page: page);
      final events = response.response?.dt ?? [];
      final totalPages = response.response?.totalPage ;

      emit(EventsLoaded(events: events, totalPages: totalPages ?? 1, currentPage: page));
    } catch (e) {
      emit(EventsError(message: e.toString()));
    }
  }
}
