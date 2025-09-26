import 'package:delhi_golf_federation/bloc/auth/auth_event.dart';
import 'package:delhi_golf_federation/bloc/auth/auth_state.dart';
import 'package:delhi_golf_federation/data/auth_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// register bloc
class RegistrationBloc extends Bloc<RegistrationEvent, RegistrationState> {
  final RegistrationRepository repository;

  RegistrationBloc(this.repository) : super(RegistrationInitial()) {
    on<SubmitRegistrationEvent>((event, emit) async {
      emit(RegistrationLoading());
      try {
        final response = await repository.registerUser(event.requestModel);
        emit(RegistrationSuccess(response));
      } catch (e) {
        emit(RegistrationFailure(e.toString()));
      }
    });
  }
}
