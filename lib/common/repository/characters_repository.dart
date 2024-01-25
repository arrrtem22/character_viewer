import 'package:cached_repository/cached_repository.dart';
import 'package:character_viewer/common/common.dart';
import 'package:injectable/injectable.dart';

@singleton
class CharactersRepository {
  CharactersRepository(CharactersApi accountApi)
      : _cachedRepo = CachedRepository.persistent(
          'account',
          fetch: (key, [__]) => accountApi.getCharacters(),
          decode: (json) => Characters.fromJson(json),
          cacheDuration: const Duration(minutes: 15),
        );

  final CachedRepository<String, Characters> _cachedRepo;

  Stream<Resource<Characters>> getCharactersStream({
    bool forceReload = false,
  }) =>
      _cachedRepo.stream('' /* you can add key */, forceReload: forceReload);

  Future<Resource<Characters>> getCharacters({
    bool forceReload = false,
  }) =>
      _cachedRepo.first('' /* you can add key */, forceReload: forceReload);

  Future<void> invalidate() => _cachedRepo.invalidate('' /* you can add key */);

  Future<void> clear() => _cachedRepo.clear();
}
