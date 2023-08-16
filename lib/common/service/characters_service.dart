import 'package:cached_repository/cached_repository.dart';
import 'package:character_viewer/common/common.dart';
import 'package:injectable/injectable.dart';

@injectable
class CharactersService {
  CharactersService({
    required CharactersRepository charactersRepository,
  }) : _charactersRepository = charactersRepository;

  final CharactersRepository _charactersRepository;

  Future<Resource<Characters>> getCharacters() =>
      _charactersRepository.getCharacters();

  Stream<Resource<Characters>> getCharactersStream() =>
      _charactersRepository.getCharactersStream();
}
