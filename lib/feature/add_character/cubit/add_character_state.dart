part of 'add_character_cubit.dart';

@freezed
class AddCharacterState with _$AddCharacterState {
  const factory AddCharacterState.initial() = AddCharacterStateInitial;
  const factory AddCharacterState.loading(Character newCharacter) =
      AddCharacterStateLoading;
  const factory AddCharacterState.success(Character newCharacter) =
      AddCharacterStateSuccess;
  const factory AddCharacterState.failure({required String error}) =
      AddCharacterStateFailure;
}
