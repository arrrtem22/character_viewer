// ignore_for_file: invalid_annotation_target

import 'package:character_viewer/common/common.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'characters.freezed.dart';
part 'characters.g.dart';

@freezed
class Characters with _$Characters {
  // very strange api
  const factory Characters({
    @JsonKey(name: 'RelatedTopics') required List<Character> characters,
  }) = _Characters;

  factory Characters.fromJson(Map<String, Object?> json) =>
      _$CharactersFromJson(json);
}
