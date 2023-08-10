import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:logger/logger.dart';

import 'common/common.dart';

Future<void> bootstrap({
  required Widget Function(RouterConfig<Object> routerConfig) builder,
  bool isDebug = kDebugMode,
}) async =>
    runZonedGuarded(
      () async {
        WidgetsFlutterBinding.ensureInitialized();

        await configureDependencies();

        runApp(builder(getIt<GoRouter>()));
      },
      (Object error, StackTrace stackTrace) => getIt<Logger>().e(
        'Uncaught exception',
        error,
        stackTrace,
      ),
    );
