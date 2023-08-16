import 'dart:async';

import 'package:cached_repository/cached_repository.dart';
import 'package:character_viewer/common/common.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';

part 'home_cubit.freezed.dart';
part 'home_state.dart';

@injectable
class HomeCubit extends Cubit<HomeState> {
  HomeCubit({required this.charactersService})
      : super(const HomeState.loading());

  final CharactersService charactersService;

  final _searchSubject = BehaviorSubject<String>.seeded('');
  StreamSubscription<FilteredResult>? _subscription;

  @override
  Future<void> close() {
    _searchSubject.close();
    _subscription?.cancel();
    _subscription = null;
    return super.close();
  }

  Future<void> init() async {
    _subscription = Rx.combineLatest2(
      charactersService.getCharactersStream(),
      _searchSubject.distinct(),
      filter,
    ).listen((result) {
      if (result.charactersResource.data != null) {
        emit(HomeState.success(
          characters: result.charactersResource.data!.characters,
        ));
      } else if (result.charactersResource.error
          is NetworkConnectionException) {
        emit(const HomeState.failure(
          type: FailureType.networkConnection,
        ));
      } else if (result.charactersResource.isError) {
        emit(const HomeState.failure(type: FailureType.unknown));
      }
    });
  }

  @visibleForTesting
  FilteredResult filter(
    Resource<Characters> charactersResource,
    String searchQuery,
  ) {
    return FilteredResult(
      charactersResource: charactersResource.map(
        (data) => filterByQuery(data, searchQuery),
      ),
      query: searchQuery,
    );
  }

  @visibleForTesting
  Characters? filterByQuery(
    Characters? source,
    String query,
  ) {
    if (source == null) return null;
    if (query.isEmpty) {
      return source;
    }
    return source.copyWith(
        characters: source.characters
            .where((character) =>
                character.title.toLowerCase().contains(query) ||
                character.description.toLowerCase().contains(query))
            .toList());
  }

  void search([String text = '']) {
    _searchSubject.add(text.toLowerCase());
  }

  void selectCharacter([Character? character]) {
    emit(state.copyWith(selected: character));
  }
}

@visibleForTesting
class FilteredResult extends Equatable {
  const FilteredResult({
    required this.charactersResource,
    required this.query,
  });

  final Resource<Characters> charactersResource;
  final String query;

  @override
  List<Object> get props => [charactersResource, query];
}
