import 'package:character_viewer/common/common.dart';
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

enum FakeApi {
  characters;

  bool get isEnabled => FakeApiManager.isFakeApiEnabled(this);

  void setEnabled(bool enabled) =>
      FakeApiManager.setFakeApiEnabled(this, enabled);
}

class FakeApiManager {
  static final _enabledFakeApi = <FakeApi>{
    // Place here fake api that should be enabled by default
    //if (kDebugMode) FakeApi.characters,
  };

  static bool isFakeApiEnabled(FakeApi api) => _enabledFakeApi.contains(api);

  static void setFakeApiEnabled(FakeApi fakeApi, bool enabled) {
    getIt<Logger>().d('FakeAPI: setFakeApiEnabled: $fakeApi => $enabled');
    if (enabled) {
      _enabledFakeApi.add(fakeApi);
    } else {
      _enabledFakeApi.remove(fakeApi);
    }
  }
}
