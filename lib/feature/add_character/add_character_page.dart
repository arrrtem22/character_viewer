import 'package:character_viewer/feature/add_character/cubit/add_character_cubit.dart';
import 'package:character_viewer/feature/add_character/cubit/add_character_state.dart';
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
        create: (context) => CharacterCubit(),
        child: AddCharacterForm(),
      ),
    );
  }
}

class AddCharacterForm extends StatelessWidget {
  final TextEditingController _nameController = TextEditingController();

  AddCharacterForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CharacterCubit, CharacterState>(
      listener: (context, state) {},
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
      return _buildSuccessUI(context);
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
            controller: _nameController,
            decoration: const InputDecoration(labelText: 'Character Name'),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              final name = _nameController.text.trim();
              if (name.isNotEmpty) {
                context.read<CharacterCubit>().addCharacter(name);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Name could not be empty'),
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

  Widget _buildSuccessUI(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.check_circle,
            color: Colors.green,
            size: 50,
          ),
          SizedBox(height: 10),
          Text(
            'Character added!',
            style: TextStyle(fontSize: 18, color: Colors.green),
          ),
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
                  .addCharacter(_nameController.text.trim());
            },
            child: const Text('Repeat'),
          ),
        ],
      ),
    );
  }
}
