import 'package:character_viewer/common/common.dart';
import 'package:go_router/go_router.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';

@module
abstract class ThirdPartyModule {
  GoRouter get router => GoRouter(routes: $appRoutes);

  Logger get logger => Logger();
}
