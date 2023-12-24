import 'package:character_viewer/common/network/dto/character.dart';
import 'package:character_viewer/common/service/character_service.dart';
import 'package:character_viewer/feature/add_character/cubit/add_character_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CharacterCubit extends Cubit<CharacterState> {
  final CharactersService _charactersService;

  CharacterCubit({
    required CharactersService charactersService,
  })  : _charactersService = charactersService,
        super(CharacterInitial());

  void addCharacter({
    required String title,
    required String imageUrl,
    required String description,
  }) {
    try {
      final newCharacter = Character(
        title: title,
        imageUrl: imageUrl,
        description: description,
      );

      _charactersService.addCharacter(newCharacter);
      emit(CharacterAddedSuccess(newCharacter));
    } catch (e) {
      emit(CharacterAddingError(
          'Something happened during loading the character: $e'));
    }
  }
}
