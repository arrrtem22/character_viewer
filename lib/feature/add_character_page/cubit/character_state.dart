abstract class CharacterState {}

class CharacterInitial extends CharacterState {}

class CharacterAddedSuccess extends CharacterState {}

class CharacterAddingError extends CharacterState {
  final String error;
  CharacterAddingError(this.error);
}
