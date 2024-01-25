import 'package:bloc_test/bloc_test.dart';
import 'package:cached_repository/cached_repository.dart';
import 'package:character_viewer/common/common.dart';
import 'package:character_viewer/feature/home/cubit/home_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../helper/mocks.mocks.dart';

void main() {
  group('HomeCubit', () {
    late MockCharactersService charactersService;
    late HomeCubit cubit;

    setUp(() {
      charactersService = MockCharactersService();
      cubit = HomeCubit(charactersService: charactersService);
    });

    tearDown(() {
      cubit.close();
    });

    test('initial state is correct', () {
      expect(cubit.state, const HomeState.loading());
    });

    const characters = Characters(characters: [
      Character(
          title: 'Character 1', description: 'Description 1', imageUrl: ''),
      Character(
          title: 'Character 2', description: 'Description 2', imageUrl: ''),
    ]);

    group('init()', () {
      blocTest<HomeCubit, HomeState>(
        'emits success state with characters when initialization is successful',
        build: () {
          when(charactersService.getCharactersStream()).thenAnswer((_) {
            return Stream.value(Resource.success(characters));
          });
          return cubit;
        },
        act: (cubit) => cubit.init(),
        expect: () => [
          HomeState.success(characters: characters.characters),
        ],
      );
    });

    group('search()', () {
      group('search by title', () {
        const searchText = 'character 1';

        blocTest<HomeCubit, HomeState>(
          'emits filtered characters when search is performed',
          build: () {
            when(charactersService.getCharactersStream()).thenAnswer((_) {
              return Stream.value(Resource.success(characters));
            });
            return cubit;
          },
          act: (cubit) {
            cubit.init();
            cubit.search(searchText);
          },
          expect: () => [
            HomeState.success(characters: characters.characters),
            const HomeState.success(characters: [
              Character(
                title: 'Character 1',
                description: 'Description 1',
                imageUrl: '',
              ),
            ]),
          ],
        );
      });

      group('search by description', () {
        const searchText = 'description 2';

        blocTest<HomeCubit, HomeState>(
          'emits filtered characters when search is performed',
          build: () {
            when(charactersService.getCharactersStream()).thenAnswer((_) {
              return Stream.value(Resource.success(characters));
            });
            return cubit;
          },
          act: (cubit) {
            cubit.init();
            cubit.search(searchText);
          },
          expect: () => [
            HomeState.success(characters: characters.characters),
            const HomeState.success(characters: [
              Character(
                title: 'Character 2',
                description: 'Description 2',
                imageUrl: '',
              ),
            ]),
          ],
        );
      });
    });

    group('selectCharacter()', () {
      const selectedCharacter = Character(
        title: 'Selected Character',
        description: 'Selected Description',
        imageUrl: '',
      );

      blocTest<HomeCubit, HomeState>(
        'emits state with selected character',
        build: () => cubit..emit(const HomeState.success()),
        act: (cubit) => cubit.selectCharacter(selectedCharacter),
        expect: () => [
          const HomeState.success(selected: selectedCharacter),
        ],
      );
    });
  });
}
