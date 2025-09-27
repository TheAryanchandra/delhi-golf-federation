import 'package:delhi_golf_federation/model/registermodel.dart';
import 'package:equatable/equatable.dart';




// register event
abstract class RegistrationEvent {}

class SubmitRegistrationEvent extends RegistrationEvent {
  final RegistrationRequestModel requestModel;

  SubmitRegistrationEvent(this.requestModel);
}


// login event

abstract class LoginEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoginSubmitted extends LoginEvent {
  final String email;
  final String password;

  LoginSubmitted(this.email, this.password);

  @override
  List<Object?> get props => [email, password];
}

// logout event
abstract class LogoutEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LogoutRequested extends LogoutEvent {}
