import 'package:delhi_golf_federation/bloc/auth/auth_event.dart';
import 'package:delhi_golf_federation/bloc/auth/auth_state.dart';
import 'package:delhi_golf_federation/data/auth_repository.dart';
import 'package:delhi_golf_federation/model/logout_model.dart';
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

// login bloc
class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final LoginRepository repository;

  LoginBloc(this.repository) : super(LoginInitial()) {
    on<LoginSubmitted>((event, emit) async {
      emit(LoginLoading());
      try {
        final response = await repository.login(
          email: event.email,
          password: event.password,
        );

        // ✅ Some APIs return lowercase keys ("status"), some return uppercase ("Status")
        final bool isSuccess = response.status;

        if (isSuccess) {
          // ✅ Save token if available
          // if (response.token != null && response.token!.isNotEmpty) {
          //   final prefs = await SharedPreferences.getInstance();
          //   await prefs.setString("auth_token", response.token!);
          // }

          emit(LoginSuccess(response));
        } else {
          // API failed, show message
          emit(
            LoginFailure(
              response.message.isNotEmpty
                  ? response.message
                  : "Invalid credentials",
            ),
          );
        }
      } catch (e) {
        emit(LoginFailure("Login failed: $e"));
      }
    });
  }
}

// logout bloc
class LogoutBloc extends Bloc<LogoutEvent, LogoutState> {
  final LogoutRepository repository;

  LogoutBloc(this.repository) : super(LogoutInitial()) {
    on<LogoutRequested>((event, emit) async {
      emit(LogoutLoading());
      try {
        final result = await repository.logout();

        if (result.status == false) {
          emit(LogoutSuccess(result.response ?? ""));
        } else {
          emit(LogoutFailure(result.message ?? "Token already expired"));
        }
      } catch (e) {
        emit(LogoutFailure("Something went wrong: $e"));
      }
    });
  }
}
