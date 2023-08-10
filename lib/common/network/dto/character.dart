// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'character.freezed.dart';
part 'character.g.dart';

@freezed
class Character with _$Character {
  // very strange api
  const factory Character({
    @JsonKey(name: 'FirstURL', fromJson: _parseTitle) required String title,
    @JsonKey(name: 'Icon', fromJson: _parseIcon) required String imageUrl,
    @JsonKey(name: 'Text') required String description,
  }) = _Character;

  factory Character.fromJson(Map<String, Object?> json) => _$CharacterFromJson(json);
}

String _parseIcon(dynamic json) => json != null ? json['URL'] : '';

String _parseTitle(String json) => json.split('/').last;