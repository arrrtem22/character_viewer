import 'package:character_viewer/common/common.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

part 'character_api.g.dart';

@RestApi()
@injectable
abstract class CharacterApi {
  @factoryMethod
  factory CharacterApi(Dio dio) => 
      FakeApi.character.isEnabled 
        ? FakeCharacterApi() 
        : _CharacterApi(dio);

  @GET('/')
  Future<void> character();
}

class FakeCharacterApi implements CharacterApi {
  @override
  Future<void> character() {
    // TODO: implement ping
    throw UnimplementedError();
  }
}
