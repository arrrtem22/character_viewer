import 'package:cached_network_image/cached_network_image.dart';
import 'package:character_viewer/common/common.dart';
import 'package:flutter/material.dart';

class DetailPage extends StatelessWidget {
  const DetailPage({super.key, required this.character});

  final Character character;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DetailView(character: character),
    );
  }
}

class DetailView extends StatelessWidget {
  const DetailView({super.key, required this.character});

  final Character character;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (character.imageUrl.isNotEmpty)
            CachedNetworkImage(
              imageUrl: resolveImageUrl(character.imageUrl),
              fadeInDuration: const Duration(seconds: 0),
              fadeOutDuration: const Duration(seconds: 0),
              placeholder: (_, __) => const Icon(Icons.ac_unit),
            ),
          Text(character.title),
          Text(character.description),
        ],
      ),
    );
  }
}
