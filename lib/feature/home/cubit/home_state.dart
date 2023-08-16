part of 'home_cubit.dart';

@freezed
class HomeState with _$HomeState {
  const factory HomeState.loading({Character? selected}) = _Loading;

  const factory HomeState.success({
    @Default([]) List<Character> characters,
    Character? selected,
  }) = _Success;

  const factory HomeState.failure({
    required FailureType type,
    Character? selected,
  }) = _Failure;
}

enum FailureType {
  networkConnection,
  unknown,
}
