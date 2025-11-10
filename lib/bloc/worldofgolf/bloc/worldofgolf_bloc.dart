import 'package:delhi_golf_federation/bloc/worldofgolf/bloc/worldofgolf_event.dart';
import 'package:delhi_golf_federation/bloc/worldofgolf/bloc/worldofgolf_state.dart';
import 'package:delhi_golf_federation/data/worldofgolf_repository.dart';
import 'package:delhi_golf_federation/model/worldofgolf_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class WorldOfGolfBloc extends Bloc<WorldOfGolfEvent, WorldOfGolfState> {
  final WorldOfGolfRepository repository;

  WorldOfGolfBloc(this.repository) : super(WorldOfGolfInitial()) {
    on<FetchWorldOfGolfEvent>((event, emit) async {
      emit(WorldOfGolfLoading());
      try {
        final payload = WorldOfGolfPayload(
          action: event.action,
          entryType: event.entryType,
          page: event.page,
        );
        final response = await repository.fetchWorldOfGolf(payload);
        emit(WorldOfGolfLoaded(
          items: response.items,
          currentPage: response.page,
          totalPage: response.totalPage,
        ));
      } catch (e) {
        emit(WorldOfGolfError(e.toString()));
      }
    });
  }
}
