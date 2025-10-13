import 'package:delhi_golf_federation/bloc/eventreport/bloc/eventreport_event.dart';
import 'package:delhi_golf_federation/bloc/eventreport/bloc/eventreport_state.dart';
import 'package:delhi_golf_federation/data/eventreport_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class EventReportBloc extends Bloc<EventReportEvent, EventReportState> {
  final EventReportRepository repository;

  EventReportBloc(this.repository) : super(EventReportInitial()) {
    on<FetchEventReport>(_onFetchEventReport);
  }

  Future<void> _onFetchEventReport(
    FetchEventReport event,
    Emitter<EventReportState> emit,
  ) async {
    emit(EventReportLoading());
    try {
      final response = await repository.fetchEvents(
        request: event.request,
        isCurrent: event.isCurrent,
      );
      emit(EventReportLoaded(response));
    } catch (e) {
      emit(EventReportError(e.toString()));
    }
  }
}
