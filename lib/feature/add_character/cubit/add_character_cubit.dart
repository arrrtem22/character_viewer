import 'package:character_viewer/common/network/dto/character.dart';
import 'package:character_viewer/common/service/character_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part 'add_character_cubit.freezed.dart';
part 'add_character_state.dart';

@injectable
class AddCharacterCubit extends Cubit<AddCharacterState> {
  final CharactersService _charactersService;

  AddCharacterCubit(this._charactersService)
      : super(const AddCharacterState.initial());

  void addCharacter({
    required String title,
    required String imageUrl,
    required String description,
  }) {
    try {
      if (title.isEmpty || imageUrl.isEmpty || description.isEmpty) {
        emit(const AddCharacterStateFailure(
          error: 'All fields must be filled',
        ));
        return;
      }

      final newCharacter = Character(
        title: title,
        imageUrl: imageUrl,
        description: description,
      );

      _charactersService.addCharacter(newCharacter);
      emit(AddCharacterStateSuccess(newCharacter));
    } catch (e) {
      emit(const AddCharacterStateFailure(
          error: 'Something happened during loading the character'));
    }
  }
}
