import 'package:character_viewer/common/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'cubit/{{name.snakeCase()}}_cubit.dart';

class {{name.pascalCase()}}Page extends StatelessWidget {
  const {{name.pascalCase()}}Page({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<{{name.pascalCase()}}Cubit>(),
      child: const Scaffold(
        body: _{{name.pascalCase()}}View(),
      ),
    );
  }
}

class _{{name.pascalCase()}}View extends StatelessWidget {
  const _{{name.pascalCase()}}View({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
