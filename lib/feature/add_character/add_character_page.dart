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
          title: const Text('Add character'),
        ),
        body: const _AddCharacterView(),
      ),
    );
  }
}

class _AddCharacterView extends StatefulWidget {
  const _AddCharacterView({Key? key}) : super(key: key);

  @override
  _AddCharacterViewState createState() => _AddCharacterViewState();
}

class _AddCharacterViewState extends State<_AddCharacterView> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController imageUrlController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

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
        } else if (state is AddCharacterStateFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: ${state.error}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: BuildUI(
            titleController: titleController,
            imageUrlController: imageUrlController,
            descriptionController: descriptionController,
            onPressed: () {
              context.read<AddCharacterCubit>().addCharacter(
                    newCharacter: Character(
                      title: titleController.text,
                      imageUrl: imageUrlController.text,
                      description: descriptionController.text,
                    ),
                  );
            },
          ),
        );
      },
    );
  }
}

class BuildUI extends StatelessWidget {
  final TextEditingController titleController;
  final TextEditingController imageUrlController;
  final TextEditingController descriptionController;
  final VoidCallback onPressed;

  const BuildUI({
    Key? key,
    required this.titleController,
    required this.imageUrlController,
    required this.descriptionController,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          NeumorphicTextFieldWidget(
            controller: titleController,
            labelText: 'Character',
          ),
          const SizedBox(height: 20),
          NeumorphicTextFieldWidget(
            controller: imageUrlController,
            labelText: 'Image URL',
          ),
          const SizedBox(height: 20),
          NeumorphicTextFieldWidget(
            controller: descriptionController,
            labelText: 'Description',
          ),
          const SizedBox(height: 20),
          AddCharacterButtonWidget(onPressed: onPressed),
        ],
      ),
    );
  }
}

class NeumorphicTextFieldWidget extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;

  const NeumorphicTextFieldWidget({
    Key? key,
    required this.controller,
    required this.labelText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey[300]!,
            offset: const Offset(5, 5),
            blurRadius: 10,
            spreadRadius: 1,
          ),
          const BoxShadow(
            color: Colors.white,
            offset: Offset(-5, -5),
            blurRadius: 10,
            spreadRadius: 1,
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: labelText,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16),
          border: InputBorder.none,
        ),
      ),
    );
  }
}

class AddCharacterButtonWidget extends StatefulWidget {
  final VoidCallback onPressed;

  const AddCharacterButtonWidget({
    Key? key,
    required this.onPressed,
  }) : super(key: key);

  @override
  State<AddCharacterButtonWidget> createState() =>
      _AddCharacterButtonWidgetState();
}

class _AddCharacterButtonWidgetState extends State<AddCharacterButtonWidget> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: widget.onPressed,
      style: ElevatedButton.styleFrom(
        primary: Colors.grey[200],
        onPrimary: Colors.grey[800],
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      child: const Text('Add character'),
    );
  }
}
