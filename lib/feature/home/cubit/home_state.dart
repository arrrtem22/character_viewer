part of 'home_cubit.dart';

@freezed
class HomeState with _$HomeState {
  const factory HomeState.general({
    @Default([]) List<Character> characters,
    Character? selected,
  }) = _Success;
}
