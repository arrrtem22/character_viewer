import 'package:adaptive_layout/adaptive_layout.dart';
import 'package:character_viewer/common/common.dart';
import 'package:character_viewer/feature/detail/detail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'cubit/home_cubit.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<HomeCubit>()..init(),
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(top: 30.0, left: 20, right: 20),
            child: AdaptiveLayout(
              smallLayout: const _SmallHomeView(),
              mediumLayout: const _LargeHomeView(),
              largeLayout: const _LargeHomeView(),
            ),
          ),
        ),
      ),
    );
  }
}

class _LargeHomeView extends StatelessWidget {
  const _LargeHomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, HomeState state) {
        return Row(
          children: [
            Expanded(
              flex: 1,
              child: Column(
                children: [
                  TextField(onChanged: context.read<HomeCubit>().search),
                  state.maybeMap(
                    general: (state) => Expanded(
                      child: ListView(
                        shrinkWrap: true,
                        children: state.characters
                            .map((character) => _CharacterItem(
                                  character: character,
                                  onTap: () => context
                                      .read<HomeCubit>()
                                      .selectCharacter(character),
                                ))
                            .toList(),
                      ),
                    ),
                    orElse: () => const Center(
                      child: CircularProgressIndicator(),
                    ),
                  )
                ],
              ),
            ),
            Expanded(
                flex: 3,
                child: state.selected != null
                    ? DetailView(character: state.selected!)
                    : const Center(child: Text('Select character'))),
            FloatingActionButton(
              onPressed: () {
                GoRouter.of(context).go('/addCharacter');
              },
              child: const Icon(Icons.add),
            ),
          ],
        );
      },
    );
  }
}

class _SmallHomeView extends StatelessWidget {
  const _SmallHomeView({Key? key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, HomeState state) {
        return Stack(
          children: [
            Column(
              children: [
                TextField(onChanged: context.read<HomeCubit>().search),
                state.maybeMap(
                  general: (state) => Expanded(
                    child: ListView(
                      shrinkWrap: true,
                      children: state.characters
                          .map((character) => _CharacterItem(
                                character: character,
                                onTap: () =>
                                    DetailRoute($extra: character).go(context),
                              ))
                          .toList(),
                    ),
                  ),
                  orElse: () => const Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
              ],
            ),
            Positioned(
              bottom: 16.0,
              right: 16.0,
              child: FloatingActionButton(
                onPressed: () => AddCharacterRoute().go(context),
                child: const Icon(Icons.add),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _CharacterItem extends StatelessWidget {
  const _CharacterItem({Key? key, required this.character, required this.onTap})
      : super(key: key);

  final Character character;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      title: Text(character.title),
    );
  }
}
