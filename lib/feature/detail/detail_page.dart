import 'package:character_viewer/common/common.dart';
import 'package:flutter/material.dart';

class DetailPage extends StatelessWidget {
  const DetailPage({super.key, required this.character});

  final Character character;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: DetailView(character: character),
      ),
    );
  }
}

class DetailView extends StatelessWidget {
  const DetailView({super.key, required this.character});

  final Character character;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(character.title),
        Text(character.title),
        Text(character.description),
      ],
    );
  }
}
