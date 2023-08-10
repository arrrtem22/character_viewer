part of 'home_cubit.dart';

@freezed
class HomeState with _$HomeState {
  const factory HomeState.general({
    @Default([])List<Topic> characters,
  }) = _Success;
}
