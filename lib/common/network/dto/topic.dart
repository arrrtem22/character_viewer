// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'topic.freezed.dart';
part 'topic.g.dart';

@freezed
class Topic with _$Topic {
  // very strange api
  const factory Topic({
    @JsonKey(name: 'FirstURL', fromJson: _parseTitle) required String title,
    @JsonKey(name: 'Icon', fromJson: _parseIcon) String? iconUrl,
    @JsonKey(name: 'Text') required String description,
  }) = _Topic;

  factory Topic.fromJson(Map<String, Object?> json) => _$TopicFromJson(json);
}

String? _parseIcon(dynamic json) => json != null ? json['URL'] : null;

String _parseTitle(String json) => json.split('/').last;