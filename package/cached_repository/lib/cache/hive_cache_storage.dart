import 'dart:convert';
import 'dart:developer';

import 'package:cached_repository/cache/cache.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:logger/logger.dart';
import 'package:synchronized/synchronized.dart';
import 'package:worker_manager/worker_manager.dart';

typedef EntityDecoder<V> = V Function(dynamic json);

class HiveCacheStorage<K, V> implements CacheStorage<K, V> {
  HiveCacheStorage(this._cacheName,
      {required EntityDecoder<V> decode, Logger? logger})
      : _encode =
            ((value) => Executor().execute(arg1: value, fun1: _jsonEncode)),
        _decode = ((data) =>
            Executor().execute(arg1: data, fun1: _jsonDecode).then(decode)),
        _logger = logger;

  static final _lock = Lock();
  static final Map<String, Box<_BoxCacheEntry>> _boxes = {};
  static Future<void>? _openDbTask;

  final Logger? _logger;
  final String _cacheName;
  final Future<String> Function(V value) _encode;
  final Future<V> Function(String data) _decode;

  @override
  Future<void> ensureInitialized() => _lock.synchronized(_initHive);

  static Future<void> clearAllStorage() async {
    await _lock.synchronized(_initHive);
    await Hive.deleteFromDisk();
    _boxes.clear();
  }

  static Future<void> _initHive() {
    var task = _openDbTask;
    if (task == null) {
      Hive.registerAdapter(_CacheEntryAdapter());
      task = _openDbTask = Hive.initFlutter();
    }
    return task;
  }

  @override
  Future<void> clear() => _ensureBox().then((box) => box.clear());

  @override
  Future<CacheEntry<V>?> get(K key) async {
    final boxKey = _resolveBoxKey(key);
    final cached = (await _ensureBox()).get(boxKey);
    if (cached != null) {
      try {
        final value = await _decode(cached.data);
        return CacheEntry(value, storeTime: cached.storeTime);
      } catch (e, trace) {
        _logger?.e('Error on load resource from [$_cacheName] by key [$boxKey]',
            e, trace);
      }
    }
    return null;
  }

  @override
  Future<void> put(K key, V data, {int? storeTime}) async {
    final boxKey = _resolveBoxKey(key);
    final entry = _BoxCacheEntry(
      await _encode(data),
      storeTime: storeTime ?? DateTime.now().millisecondsSinceEpoch,
    );
    final box = await _ensureBox();
    await box.put(boxKey, entry);
  }

  @override
  Future<void> delete(K key) async {
    final boxKey = _resolveBoxKey(key);
    await (await _ensureBox()).delete(boxKey);
  }

  String _resolveBoxKey(K key) => key.toString();

  Future<Box<_BoxCacheEntry>> _ensureBox() => _lock.synchronized(() async {
        Box<_BoxCacheEntry>? box = _boxes[_cacheName];
        if (box == null) {
          try {
            await _initHive();
            box = await Hive.openBox(_cacheName);
          } catch (e, trace) {
            _logger?.e(
                'Error on open box [$_cacheName] => delete and try again!',
                e,
                trace);
            Hive.deleteBoxFromDisk(_cacheName);
            box = await Hive.openBox(_cacheName);
          }
          _boxes[_cacheName] = box;
        }
        return box;
      });

  @override
  String toString() => 'HiveCacheStorage($_cacheName)';
}

class _BoxCacheEntry {
  _BoxCacheEntry(this.data, {required this.storeTime});

  String data;
  int storeTime;
}

class _CacheEntryAdapter extends TypeAdapter<_BoxCacheEntry> {
  @override
  final typeId = 0;

  @override
  _BoxCacheEntry read(BinaryReader reader) {
    return _BoxCacheEntry(reader.read(), storeTime: reader.read());
  }

  @override
  void write(BinaryWriter writer, _BoxCacheEntry obj) {
    writer.write(obj.data);
    writer.write(obj.storeTime);
  }
}

String _jsonEncode<V>(V value) {
  try {
    return json.encode(value);
  } catch (e, trace) {
    log('Error while encoding Resource: $value', error: e, stackTrace: trace);
    rethrow;
  }
}

dynamic _jsonDecode(String data) {
  try {
    return json.decode(data);
  } catch (e, trace) {
    log('Error while decoding Resource: $data', error: e, stackTrace: trace);
    rethrow;
  }
}
