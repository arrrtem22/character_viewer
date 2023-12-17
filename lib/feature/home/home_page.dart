import 'package:adaptive_layout/adaptive_layout.dart';
import 'package:character_viewer/common/common.dart';
import 'package:character_viewer/feature/add_character_page/add_character.dart';
import 'package:character_viewer/feature/detail/detail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AddCharacterPage(),
                  ),
                );
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
  const _SmallHomeView();

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
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AddCharacterPage(),
                    ),
                  );
                },
                child: const Icon(Icons.add),
              ),
            ),
          ],
        );
      },
    );
  }
}

// class _CharacterItem extends StatelessWidget {
//   const _CharacterItem({Key? key, required this.character, required this.onTap})
//       : super(key: key);

//   final Character character;
//   final VoidCallback onTap;

//   @override
//   Widget build(BuildContext context) {
//     return ListTile(
//       onTap: onTap,
//       title: Text(character.title),
//     );
//   }
// }

class _CharacterItem extends StatelessWidget {
  const _CharacterItem({Key? key, required this.character, required this.onTap})
      : super(key: key);

  final Character character;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              const Icon(Icons.person, size: 48.0),
              const SizedBox(width: 16.0),
              Expanded(
                child: Text(
                  character.title,
                  style: Theme.of(context).textTheme.subtitle1,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
