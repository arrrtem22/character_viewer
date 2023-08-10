// coverage:ignore-file
import 'package:cached_repository/cached_repository.dart';
import 'package:character_viewer/common/injection/dependencies.config.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';

final getIt = GetIt.instance;

@InjectableInit()
Future<void> configureDependencies() async {
  await getIt.init();
  CachedRepository.logger = getIt<Logger>();
}
