import 'package:flutter/material.dart';

class Application extends StatelessWidget {
  const Application(
    this.routerConfig, {
    super.key,
  });

  final RouterConfig<Object> routerConfig;

  static final navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      key: navigatorKey,
      routerConfig: routerConfig,
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaleFactor: 1),
          child: child ?? const SizedBox.shrink(),
        );
      },
    );
  }
}
