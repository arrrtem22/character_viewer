import 'package:character_viewer/common/common.dart';
import 'package:flutter/material.dart';

class DetailPage extends StatelessWidget {
  const DetailPage({super.key, required this.character});

  final Character character;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: DetailView(character: character)),
    );
  }
}

class DetailView extends StatelessWidget {
  const DetailView({super.key, required this.character});

  final Character character;

  @override
  Widget build(BuildContext context) {
    return Center(child: Text(character.title));
  }
}
