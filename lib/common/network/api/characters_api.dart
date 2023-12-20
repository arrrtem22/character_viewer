import 'package:character_viewer/common/common.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';
import 'package:character_viewer/common/common.dart';

part 'characters_api.g.dart';

@RestApi()
@injectable
abstract class CharactersApi {
  @factoryMethod
  factory CharactersApi(Dio dio) =>
      FakeApi.characters.isEnabled ? FakeCharactersApi() : _CharactersApi(dio);

  @GET('')
  Future<Characters> getCharacters();

  @POST('')
  Future<Characters> addCharacter();
}

class FakeCharactersApi implements CharactersApi {
  @override
  Future<Characters> getCharacters() async {
    // Simulate fetching characters from a fake API
    final fakeCharacters = [
      const Character(
        title: 'Fake Character 1',
        imageUrl: 'https://via.placeholder.com/600/92c952',
        description: 'This is a fake character description.',
      ),
      const Character(
        title: 'Fake Character 2',
        imageUrl: 'https://via.placeholder.com/600/7286a7',
        description: 'Another fake character description.',
      ),
    ];

    final fakeResponse = Characters(characters: fakeCharacters);

    await Future.delayed(const Duration(seconds: 2));

    return fakeResponse;
  }

  @override
  Future<Characters> addCharacter() async {
    final fakeResponse = Characters(characters: []);
    return fakeResponse;
  }
}
