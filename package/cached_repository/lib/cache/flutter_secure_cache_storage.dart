import 'dart:convert';
import 'dart:developer';

import 'package:cached_repository/cache/cache.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:logger/logger.dart';
import 'package:worker_manager/worker_manager.dart';

typedef SecureEntityDecoder<V> = V Function(dynamic json);

class FlutterSecureCacheStorage<K, V> implements CacheStorage<K, V> {
  FlutterSecureCacheStorage(
    this.keyPrefix, {
    required SecureEntityDecoder<V> decode,
    Logger? logger,
  })  : _encode =
            ((value) => Executor().execute(arg1: value, fun1: _jsonEncode)),
        _decode = ((data) => Executor()
            .execute(arg1: data, fun1: _jsonDecode)
            .then((value) => _BoxCacheEntry.fromJson(value, decode))),
        _logger = logger;

  static const _box = FlutterSecureStorage(
    iOptions:
        IOSOptions(accessibility: KeychainAccessibility.unlocked_this_device),
    aOptions: AndroidOptions(resetOnError: true),
  );
  final Logger? _logger;
  final String keyPrefix;
  final Future<String> Function(_BoxCacheEntry<V> value) _encode;
  final Future<_BoxCacheEntry<V>> Function(String data) _decode;

  @override
  Future<void> ensureInitialized() => Future.value();

  static Future<void> clearAllStorage() async {
    await _box.deleteAll();
  }

  @override
  Future<void> clear() =>
      throw UnsupportedError('Clear not supported. Use #clearAllStorage');

  @override
  Future<CacheEntry<V>?> get(K key) async {
    final boxKey = _resolveBoxKey(key);
    final cachedJson = await _box.read(key: boxKey);
    if (cachedJson != null) {
      try {
        final cacheEntry = await _decode(cachedJson);
        return cacheEntry;
      } catch (e, trace) {
        _logger?.e('Error on load resource from SecureStorage by key [$boxKey]',
            e, trace);
      }
    }
    return null;
  }

  @override
  Future<void> put(K key, V data, {int? storeTime}) async {
    final boxKey = _resolveBoxKey(key);
    final entry = _BoxCacheEntry(
      data,
      storeTime: storeTime ?? DateTime.now().millisecondsSinceEpoch,
    );
    final value = await _encode(entry);
    await _box.write(key: boxKey, value: value);
  }

  @override
  Future<void> delete(K key) async {
    final boxKey = _resolveBoxKey(key);
    await _box.delete(key: boxKey);
  }

  String _resolveBoxKey(K key) => '$keyPrefix:${key.toString()}';

  @override
  String toString() => 'FlutterSecureCacheStorage';
}

class _BoxCacheEntry<V> extends CacheEntry<V> {
  _BoxCacheEntry(V data, {required int storeTime})
      : super(data, storeTime: storeTime);

  Map<String, dynamic> toJson() => {
        'data': data,
        'storeTime': storeTime,
      };

  // ignore: sort_constructors_first
  factory _BoxCacheEntry.fromJson(
          Map<String, dynamic> json, SecureEntityDecoder<V> dataDecoder) =>
      _BoxCacheEntry(
        dataDecoder(json['data']),
        storeTime: json['storeTime'] as int,
      );
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
