import 'package:delhi_golf_federation/bloc/eventregister/bloc/eventregister_event.dart';
import 'package:delhi_golf_federation/bloc/eventregister/bloc/eventregister_state.dart';
import 'package:delhi_golf_federation/data/eventregister_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class EventRegistrationBloc extends Bloc<EventRegistrationEvent, EventRegistrationState> {
  final EventRegistrationRepository repository;

  EventRegistrationBloc(this.repository) : super(EventRegistrationInitial()) {
    on<SubmitEventRegistration>(_onSubmitEventRegistration);
  }

  Future<void> _onSubmitEventRegistration(
    SubmitEventRegistration event,
    Emitter<EventRegistrationState> emit,
  ) async {
    emit(EventRegistrationLoading());
    try {
      final response = await repository.registerEvent(event.request);
      emit(EventRegistrationSuccess(response));
    } catch (e) {
      emit(EventRegistrationFailure(e.toString()));
    }
  }
}
