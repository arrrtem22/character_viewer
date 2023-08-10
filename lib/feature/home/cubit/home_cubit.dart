import 'package:character_viewer/common/common.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part 'home_cubit.freezed.dart';
part 'home_state.dart';

@injectable
class HomeCubit extends Cubit<HomeState> {
  HomeCubit({required this.charactersService})
      : super(const HomeState.initial());

  final CharactersService charactersService;

  Future<void> fetchCharacters() async {
    final characters = await charactersService.getCharacters();
    emit(HomeState.success(characters: characters));
  }
}
