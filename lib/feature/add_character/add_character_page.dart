import 'package:character_viewer/common/network/api/characters_api.dart';
import 'package:character_viewer/common/network/dto/character.dart';
import 'package:character_viewer/common/service/character_service.dart';
import 'package:character_viewer/feature/add_character/cubit/add_character_cubit.dart';
import 'package:character_viewer/feature/add_character/cubit/add_character_state.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddCharacterPage extends StatelessWidget {
  const AddCharacterPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Character'),
      ),
      body: BlocProvider(
        create: (context) => CharacterCubit(
          charactersService: CharactersService(
            charactersApi: CharactersApi(Dio()),
          ),
        ),
        child: AddCharacterForm(),
      ),
    );
  }
}

class AddCharacterForm extends StatelessWidget {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController imageUrlController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  AddCharacterForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CharacterCubit, CharacterState>(
      listener: (context, state) {
        if (state is CharacterAddedSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Character added: ${state.character.title}'),
              backgroundColor: Colors.green,
            ),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: _buildUI(context, state),
        );
      },
    );
  }

  Widget _buildUI(BuildContext context, CharacterState state) {
    if (state is CharacterInitial) {
      return _buildInitialUI(context);
    } else if (state is CharacterAddedSuccess) {
      return _buildSuccessUI(context, state.character);
    } else if (state is CharacterAddingError) {
      return _buildErrorUI(context, state.error);
    } else {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
  }

  Widget _buildInitialUI(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          TextField(
            controller: titleController,
            decoration: const InputDecoration(labelText: 'Character Title'),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: imageUrlController,
            decoration: const InputDecoration(labelText: 'Image URL'),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: descriptionController,
            decoration:
                const InputDecoration(labelText: 'Character Description'),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              final title = titleController.text.trim();
              final imageUrl = imageUrlController.text.trim();
              final description = descriptionController.text.trim();

              if (title.isNotEmpty &&
                  imageUrl.isNotEmpty &&
                  description.isNotEmpty) {
                context.read<CharacterCubit>().addCharacter(
                      title: title,
                      imageUrl: imageUrl,
                      description: description,
                    );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('All fields must be filled'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            child: const Text('Add Character'),
          ),
        ],
      ),
    );
  }

  Widget _buildSuccessUI(BuildContext context, Character character) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.check_circle,
            color: Colors.green,
            size: 50,
          ),
          const SizedBox(height: 10),
          const Text(
            'Character added!',
            style: TextStyle(fontSize: 18, color: Colors.green),
          ),
          // show added items
          Text('Title: ${character.title}'),
          Text('Image URL: ${character.imageUrl}'),
          Text('Description: ${character.description}'),
        ],
      ),
    );
  }

  Widget _buildErrorUI(BuildContext context, String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error,
            color: Colors.red,
            size: 50,
          ),
          const SizedBox(height: 10),
          Text(
            'Error: $error',
            style: const TextStyle(fontSize: 18, color: Colors.red),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              context
                  .read<CharacterCubit>()
                  .addCharacter(title: '', imageUrl: '', description: '');
            },
            child: const Text('Repeat'),
          ),
        ],
      ),
    );
  }
}
