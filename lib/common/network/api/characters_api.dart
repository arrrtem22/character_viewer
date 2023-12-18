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
  Future<Characters> addCharacter();
}

class FakeCharactersApi implements CharactersApi {
  @override
  Future<Characters> getCharacters() {
    // TODO: implement ping
    throw UnimplementedError();
  }

  @override
  Future<Characters> addCharacter() {
    // TODO: implement addCharacter
    throw UnimplementedError();
  }
}
