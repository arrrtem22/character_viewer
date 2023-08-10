import 'package:character_viewer/common/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'cubit/home_cubit.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<HomeCubit>()..init(),
      child: const Scaffold(
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.only(top: 30.0, left: 20, right: 20),
            child: HomeView(),
          ),
        ),
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
        return Column(
          children: [
            TextField(onChanged: context.read<HomeCubit>().search),
            state.maybeMap(
              general: (state) => Expanded(
                child: ListView(
                  shrinkWrap: true,
                  children: state.characters
                      .map((character) => _CharacterItem(character: character))
                      .toList(),
                ),
              ),
              orElse: () => const Center(
                child: CircularProgressIndicator(),
              ),
            )
          ],
        );
      },
    );
  }
}

class _CharacterItem extends StatelessWidget {
  const _CharacterItem({Key? key, required this.character}) : super(key: key);

  final Character character;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () => DetailRoute($extra: character).go(context),
      title: Text(character.title),
    );
  }
}
