import 'package:delhi_golf_federation/bloc/eventdetails/bloc/eventdetails_event.dart';
import 'package:delhi_golf_federation/bloc/eventdetails/bloc/eventdetails_state.dart';
import 'package:delhi_golf_federation/data/eventdetails_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class EventDetailsBloc extends Bloc<EventDetailsEvent, EventDetailsState> {
  final EventDetailsRepository repository;

  EventDetailsBloc(this.repository) : super(EventDetailsInitial()) {
    on<FetchEventDetailsEvent>((event, emit) async {
      emit(EventDetailsLoading());
      try {
        final eventDetails = await repository.fetchEventDetails(event.refNo);
        emit(EventDetailsLoaded(eventDetails));
      } catch (e) {
        emit(EventDetailsError(e.toString()));
      }
    });
  }
}
