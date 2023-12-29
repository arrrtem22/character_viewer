import 'package:character_viewer/common/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'cubit/add_character_cubit.dart';

class AddCharacterPage extends StatelessWidget {
  const AddCharacterPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<AddCharacterCubit>(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Add Character'),
        ),
        body: _AddCharacterView(),
      ),
    );
  }
}

class _AddCharacterView extends StatelessWidget {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController imageUrlController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  _AddCharacterView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AddCharacterCubit, AddCharacterState>(
      listener: (context, state) {
        if (state is AddCharacterStateSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Character added: ${state.newCharacter.title}'),
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

  Widget _buildUI(BuildContext context, AddCharacterState state) {
    if (state is AddCharacterStateInitial) {
      return _buildInitialUI(context);
    } else if (state is AddCharacterStateSuccess) {
      return _buildSuccessUI(context, state.newCharacter);
    } else if (state is AddCharacterStateFailure) {
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
          _buildNeumorphicTextField(titleController, 'Character Title'),
          const SizedBox(height: 20),
          _buildNeumorphicTextField(imageUrlController, 'Image URL'),
          const SizedBox(height: 20),
          _buildNeumorphicTextField(
            descriptionController,
            'Character Description',
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
                context.read<AddCharacterCubit>().addCharacter(
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
            style: ElevatedButton.styleFrom(
              primary: Colors.grey[200], // фон кнопки
              onPrimary: Colors.grey[800], // цвет текста кнопки
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: const Text('Add Character'),
          ),
        ],
      ),
    );
  }

  Widget _buildNeumorphicTextField(
      TextEditingController controller, String labelText) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200], // Цвет фона текстового поля
        borderRadius:
            BorderRadius.circular(16), // Скругление углов текстового поля
        boxShadow: [
          BoxShadow(
            color: Colors.grey[300]!, // Цвет тени
            offset: Offset(5, 5), // Смещение тени по X и Y
            blurRadius: 10, // Радиус размытия тени
            spreadRadius: 1, // Размах тени
          ),
          BoxShadow(
            color: Colors.white, // Цвет второй тени (белая)
            offset: Offset(-5, -5), // Смещение второй тени по X и Y
            blurRadius: 10, // Радиус размытия второй тени
            spreadRadius: 1, // Размах второй тени
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: labelText,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16),
          border: InputBorder.none, // Убираем границы текстового поля
        ),
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
                  .read<AddCharacterCubit>()
                  .addCharacter(title: '', imageUrl: '', description: '');
            },
            child: const Text('Repeat'),
          ),
        ],
      ),
    );
  }
}
