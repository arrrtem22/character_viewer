import 'package:character_viewer/common/network/dto/character.dart';

abstract class CharacterState {}

class CharacterInitial extends CharacterState {}

class CharacterAddedSuccess extends CharacterState {
  final Character character;
  CharacterAddedSuccess(this.character);
}

class CharacterAddingError extends CharacterState {
  final String error;
  CharacterAddingError(this.error);
}
