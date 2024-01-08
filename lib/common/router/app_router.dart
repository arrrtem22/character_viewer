import 'package:character_viewer/common/common.dart';
import 'package:character_viewer/feature/add_character/add_character_page.dart';
import 'package:character_viewer/feature/feature.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

part 'app_router.g.dart';

@TypedGoRoute<HomeRoute>(
  path: '/',
  routes: [
    TypedGoRoute<DetailRoute>(
      path: 'detail',
    ),
    TypedGoRoute<AddCharacterRoute>(
      path: 'addCharacter',
    ),
  ],
)
class HomeRoute extends GoRouteData {
  const HomeRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) => const HomePage();
}

class DetailRoute extends GoRouteData {
  DetailRoute({this.$extra});

  final Character? $extra;

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      DetailPage(character: $extra!);
}

class AddCharacterRoute extends GoRouteData {
  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const AddCharacterPage();
}
