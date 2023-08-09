// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'topic.freezed.dart';
part 'topic.g.dart';

@freezed
class Topic with _$Topic {
  // very strange api
  const factory Topic({
    @JsonKey(name: 'FirstURL') required String title,
    @JsonKey(fromJson: _parseIcon) required String iconUrl,
    @JsonKey(name: 'Text') required String description,
  }) = _Topic;

  static String _parseIcon(dynamic json) => json['Icon']['URL'];

  factory Topic.fromJson(Map<String, Object?> json) => _$TopicFromJson(json);
}
