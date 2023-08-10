import 'package:character_viewer/common/common.dart';

String resolveImageUrl(String rawUrl) {
  return rawUrl.startsWith('/')
      ? (getIt<Config>().cdnUrl.toString() + rawUrl)
      : rawUrl;
}