// ignore_for_file: inference_failure_on_instance_creation, depend_on_referenced_packages

import 'package:character_viewer/common/common.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

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
  Future<void> addCharacter(
    @Body() Character newCharacter,
  );
}

class FakeCharactersApi implements CharactersApi {
  // variable in FakeCharactersApi for ex fakeCharacters and work with it
  List<Character> fakeCharacters = [
    Character(
      title: 'Fake Character 1',
      imageUrl: 'https://via.placeholder.com/600/92c952',
      description: 'This is a fake character description.',
    ),
    Character(
      title: 'Fake Character 2',
      imageUrl: 'https://via.placeholder.com/600/7286a7',
      description: 'Another fake character description.',
    ),
  ];

  @override
  Future<Characters> getCharacters() async {
    await Future.delayed(const Duration(seconds: 2));

    return Characters(characters: fakeCharacters);
  }

  @override
  Future<void> addCharacter(@Body() Character newCharacter) async {
    await Future.delayed(const Duration(seconds: 2));
    fakeCharacters.add(newCharacter);
    print('all $fakeCharacters');
  }
}
