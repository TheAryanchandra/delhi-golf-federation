abstract class AuthState {}

class UpdateProfileInitial extends AuthState {}

class UpdateProfileLoading extends AuthState {}

class UpdateProfileSuccess extends AuthState {
  final String message;
  UpdateProfileSuccess(this.message);
}

class UpdateProfileFailure extends AuthState {
  final String error;
  UpdateProfileFailure(this.error);
}
