import 'dart:async';

import 'package:character_viewer/common/common.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';

part 'home_cubit.freezed.dart';
part 'home_state.dart';

@injectable
class HomeCubit extends Cubit<HomeState> {
  HomeCubit({required this.charactersService})
      : super(const HomeState.general());

  final CharactersService charactersService;

  final _searchSubject = BehaviorSubject<String>.seeded('');
  StreamSubscription<String>? _subscription;

  @override
  Future<void> close() {
    _searchSubject.close();
    _subscription?.cancel();
    _subscription = null;
    return super.close();
  }

  Future<void> init() async {
    final characters = (await charactersService.getCharacters()).characters;
    _subscription = _searchSubject.listen((text) {
      if (text.isEmpty) return;
      final filteredCharacters = characters
          .where((character) =>
              character.title.toLowerCase().contains(text) ||
              character.description.toLowerCase().contains(text))
          .toList();
      emit(state.copyWith(characters: filteredCharacters));
    });
    emit(HomeState.general(characters: characters));
  }

  void search([String text = '']) {
    _searchSubject.add(text.toLowerCase());
  }

  void selectCharacter([Character? character]) {
    emit(state.copyWith(selected: character));
  }
}
