

import 'package:delhi_golf_federation/model/industrymodel.dart';
import 'package:delhi_golf_federation/model/login_model.dart';
import 'package:delhi_golf_federation/model/refresh_token_model.dart';
import 'package:delhi_golf_federation/model/registermodel.dart';
import 'package:equatable/equatable.dart';

// register state

abstract class RegistrationState {}

class RegistrationInitial extends RegistrationState {}

class RegistrationLoading extends RegistrationState {}

class RegistrationSuccess extends RegistrationState {
  final RegistrationResponseModel response;

  RegistrationSuccess(this.response);
}

class RegistrationFailure extends RegistrationState {
  final String error;

  RegistrationFailure(this.error);
}

// login state
abstract class LoginState extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class LoginSuccess extends LoginState {
  final LoginResponse response;
  LoginSuccess(this.response);

  @override
  List<Object?> get props => [response];
}

class LoginFailure extends LoginState {
  final String error;
  final int? statusCode;
  LoginFailure(this.error, {this.statusCode});

  @override
  List<Object?> get props => [error, statusCode];
}

// logout state
abstract class LogoutState extends Equatable {
  @override
  List<Object?> get props => [];
}

class LogoutInitial extends LogoutState {}
class LogoutLoading extends LogoutState {}
class LogoutSuccess extends LogoutState {
  final String message;
  LogoutSuccess(this.message);

  @override
  List<Object?> get props => [message];
}
class LogoutFailure extends LogoutState {
  final String error;
  LogoutFailure(this.error);

  @override
  List<Object?> get props => [error];
}


// industry 
abstract class IndustryState extends Equatable {
  @override
  List<Object?> get props => [];
}

class IndustryInitial extends IndustryState {}

class IndustryLoading extends IndustryState {}

class IndustryLoaded extends IndustryState {
  final List<IndustryModel> industries;

  IndustryLoaded(this.industries);

  @override
  List<Object?> get props => [industries];
}

class IndustryError extends IndustryState {
  final String message;

  IndustryError(this.message);

  @override
  List<Object?> get props => [message];
}

// refresh token 
abstract class RefreshTokenState extends Equatable {
  @override
  List<Object?> get props => [];
}

class RefreshTokenInitial extends RefreshTokenState {}

class RefreshTokenLoading extends RefreshTokenState {}

class RefreshTokenSuccess extends RefreshTokenState {
  final RefreshTokenModel model;

  RefreshTokenSuccess(this.model);

  @override
  List<Object?> get props => [model];
}

class RefreshTokenFailure extends RefreshTokenState {
  final String error;

  RefreshTokenFailure(this.error);

  @override
  List<Object?> get props => [error];
}