import 'package:equatable/equatable.dart';

abstract class UserDataEvent extends Equatable {
  const UserDataEvent();

  @override
  List<Object?> get props => [];
}

class FetchUserDataEvent extends UserDataEvent {}
