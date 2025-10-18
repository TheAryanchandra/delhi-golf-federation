import 'dart:async';
import 'package:delhi_golf_federation/bloc/updateimage/bloc/updateimage_event.dart';
import 'package:delhi_golf_federation/bloc/updateimage/bloc/updateimage_state.dart';
import 'package:delhi_golf_federation/data/updateimage_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class UpdateProfileBloc extends Bloc<AuthEvent, AuthState> {
  final UpdateProfileRepository repository;

  UpdateProfileBloc(this.repository) : super(UpdateProfileInitial()) {
    on<UpdateProfileEvent>(_onUpdateProfile);
  }

  Future<void> _onUpdateProfile(UpdateProfileEvent event, Emitter<AuthState> emit) async {
    emit(UpdateProfileLoading());
    try {
      final response = await repository.updateProfile(event.model, event.imageFile);
      if (response.statusCode == 200) {
        emit(UpdateProfileSuccess(response.data.toString()));
      } else {
        emit(UpdateProfileFailure("Error ${response.statusCode}: ${response.data}"));
      }
    } catch (e) {
      emit(UpdateProfileFailure(e.toString()));
    }
  }
}
