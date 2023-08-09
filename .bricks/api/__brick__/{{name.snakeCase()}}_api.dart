import 'package:character_viewer/common/common.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

part '{{name.snakeCase()}}_api.g.dart';

@RestApi()
@injectable
abstract class {{name.pascalCase()}}Api {
  @factoryMethod
  factory {{name.pascalCase()}}Api(Dio dio) => 
      FakeApi.{{name.camelCase()}}.isEnabled 
        ? Fake{{name.pascalCase()}}Api() 
        : _{{name.pascalCase()}}Api(dio);

  @GET('/ping')
  Future<void> ping();
}

class Fake{{name.pascalCase()}}Api implements {{name.pascalCase()}}Api {
  @override
  Future<void> ping() {
    // TODO: implement ping
    throw UnimplementedError();
  }
}
