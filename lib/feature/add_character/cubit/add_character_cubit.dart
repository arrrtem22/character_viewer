import 'package:character_viewer/feature/add_character/cubit/add_character_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CharacterCubit extends Cubit<CharacterState> {
  CharacterCubit() : super(CharacterInitial());

  void addCharacter(String name) {
    try {
      emit(CharacterAddedSuccess());
    } catch (e) {
      emit(CharacterAddingError(
          'Something happend during loading the character: $e'));
    }
  }
}
