import 'package:flutter_bloc/flutter_bloc.dart';

import 'character_state.dart';

class CharacterCubit extends Cubit<CharacterState> {
  CharacterCubit() : super(CharacterInitial());

  void addCharacter(String name) {
    try {
      emit(CharacterAddedSuccess());
    } catch (e) {
      emit(CharacterAddingError('Error during adding the character: $e'));
    }
  }
}
