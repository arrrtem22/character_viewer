import 'package:cached_repository/cached_repository.dart';
import 'package:character_viewer/common/common.dart';
import 'package:injectable/injectable.dart';

@injectable
class CharactersService {
  CharactersService({
    required CharactersRepository charactersRepository,
    required CharactersApi charactersApi,
  })  : _charactersRepository = charactersRepository,
        _charactersApi = charactersApi;

  final CharactersRepository _charactersRepository;
  final CharactersApi _charactersApi;

  Future<Resource<Characters>> getCharacters() =>
      _charactersRepository.getCharacters();

  Stream<Resource<Characters>> getCharactersStream() =>
      _charactersRepository.getCharactersStream();

  Future<void> addCharacter(Character newCharacter) async {
    await _charactersApi.addCharacter(newCharacter);
    invalidate();
  }

  Future<void> invalidate() => _charactersRepository.invalidate();
}
