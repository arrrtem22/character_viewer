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

  @POST(
      'addCharacter') // Предполагается, что у вас есть конечная точка для добавления персонажей
  Future<void> addCharacter(@Body() String characterName);
}

class FakeCharactersApi implements CharactersApi {
  @override
  Future<Characters> getCharacters() {
    // TODO: реализовать метод getCharacters
    throw UnimplementedError();
  }

  @override
  Future<void> addCharacter(String characterName) {
    // TODO: реализовать метод addCharacter
    throw UnimplementedError();
  }
}
