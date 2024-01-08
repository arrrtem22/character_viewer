import 'package:character_viewer/common/common.dart';
import 'package:injectable/injectable.dart';

@injectable
class CharactersService {
  CharactersService({
    required CharactersApi charactersApi,
  }) : _charactersApi = charactersApi;

  final CharactersApi _charactersApi;

  Future<Characters> getCharacters() => _charactersApi.getCharacters();

  Future<void> addCharacter(Character newCharacter) =>
      _charactersApi.addCharacter(newCharacter);
}
