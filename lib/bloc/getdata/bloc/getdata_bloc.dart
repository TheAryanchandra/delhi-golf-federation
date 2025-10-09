import 'package:delhi_golf_federation/bloc/getdata/bloc/getdata_event.dart';
import 'package:delhi_golf_federation/bloc/getdata/bloc/getdata_state.dart';
import 'package:delhi_golf_federation/data/getdatarepository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';



class UserDataBloc extends Bloc<UserDataEvent, UserDataState> {
  final AuthRepository authRepository;

  UserDataBloc({required this.authRepository}) : super(UserDataInitial()) {
    on<FetchUserDataEvent>(_onFetchUserData);
  }

  Future<void> _onFetchUserData(
      FetchUserDataEvent event, Emitter<UserDataState> emit) async {
    emit(UserDataLoading());
    try {
      final userData = await authRepository.fetchUserData();
      emit(UserDataLoaded(userData));
    } catch (e) {
      emit(UserDataError(e.toString()));
    }
  }
}
