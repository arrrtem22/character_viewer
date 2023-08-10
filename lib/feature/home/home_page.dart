import 'package:character_viewer/common/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'cubit/home_cubit.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<HomeCubit>()..fetchCharacters(),
      child: const Scaffold(
        body: HomeView(),
      ),
    );
  }
}

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, HomeState state) {
        return state.maybeMap(
          success: (state) => ListView(
            children: state.characters.relatedTopics
                .map((character) => _CharacterItem(character: character))
                .toList(),
          ),
          orElse: () => const Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}

class _CharacterItem extends StatelessWidget {
  const _CharacterItem({Key? key, required this.character}) : super(key: key);

  final Topic character;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(character.title),
    );
  }
}
