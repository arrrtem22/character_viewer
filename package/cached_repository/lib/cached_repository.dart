import 'dart:async';

import 'package:cached_repository/cache/cache.dart';
import 'package:cached_repository/cache/flutter_secure_cache_storage.dart';
import 'package:cached_repository/network_bound_resource.dart';
import 'package:cached_repository/resource.dart';
import 'package:logger/logger.dart';
import 'package:rxdart/rxdart.dart';
import 'package:synchronized/synchronized.dart';

export 'resource.dart';

/// The abstract repository with cache,
/// inspired by Google's NetworkBoundResource.
///
/// Example:
///
/// ```dart
/// final repo = CachedRepository.<String, Wallet>persistent(
///     'cacheName1',
///     fetch: (key, _) => _api.getWalletById(key),
///     decode: (json) => Wallet.fromJson(json),
///     cacheDuration: const Duration(minutes: 30),
///     );
///
/// void listenForWalletUpdates() {
///   subscription = repo.stream(_walletId)
///       .listen((wallet) => _onWalletUpdated(wallet));
/// }
///
/// //or
/// void getWalletFromCacheOrFetch() async {
///   final wallet = await repo.first(_walletId);
///   //handle wallet...
/// }
///
/// ```
class CachedRepository<K, V> {

  static Logger? logger;

  CachedRepository({
    FetchCallable<K, V>? fetch,
    required CacheStorage<K, V> storage,
    Duration? cacheDuration,
    CacheDurationResolver<K, V>? cacheDurationResolver,
  })  : _fetch = fetch,
        _storage = storage,
        _cacheDurationResolver =
            (cacheDurationResolver ?? (k, v) => cacheDuration ?? Duration.zero);

  CachedRepository.persistent(String cacheName,
      {FetchCallable<K, V>? fetch,
      required EntityDecoder<V> decode,
      Duration? cacheDuration,
      CacheDurationResolver<K, V>? cacheDurationResolver,
      Logger? logger})
      : _fetch = fetch,
        _storage = HiveCacheStorage(cacheName, decode: decode, logger: logger),
        _cacheDurationResolver =
            (cacheDurationResolver ?? (k, v) => cacheDuration ?? Duration.zero);

  CachedRepository.secureStorage(
    String cacheName, {
    required EntityDecoder<V> decode,
    FetchCallable<K, V>? fetch,
    Duration? cacheDuration,
    CacheDurationResolver<K, V>? cacheDurationResolver,
    Logger? logger,
  })  : _fetch = fetch,
        _storage = FlutterSecureCacheStorage(cacheName,
            decode: decode, logger: logger),
        _cacheDurationResolver =
            (cacheDurationResolver ?? (k, v) => cacheDuration ?? Duration.zero);

  CachedRepository.inMemory(
    String cacheName, {
    FetchCallable<K, V>? fetch,
    Duration? cacheDuration,
    CacheDurationResolver<K, V>? cacheDurationResolver,
  })  : _fetch = fetch,
        _storage = MemoryCacheStorage(cacheName),
        _cacheDurationResolver =
            (cacheDurationResolver ?? (k, v) => cacheDuration ?? Duration.zero);

  final Map<K, NetworkBoundResource<K, V>> _resources = {};
  final FetchCallable<K, V>? _fetch;
  final CacheDurationResolver<K, V> _cacheDurationResolver;
  final _lock = Lock();
  final CacheStorage<K, V> _storage;

  /// Returns stream of Resource by unique [key].
  /// It's common to use entity id as [key].
  Stream<Resource<V>> stream(
    K key, {
    bool forceReload = false,
    dynamic fetchArguments,
    bool skipEmptyLoading = false,
  }) {
    return _ensureResource(key)
        .asStream()
        .switchMap((resource) => resource.load(
              forceReload: forceReload,
              skipEmptyLoading: skipEmptyLoading,
              fetchArguments: fetchArguments,
            ));
  }

  /// Returns Resource by unique [key].
  /// Returns cached item if not stale, else returns newly fetched item.
  Future<Resource<V>> first(
    K key, {
    bool forceReload = false,
    dynamic fetchArguments,
  }) =>
      stream(
        key,
        forceReload: forceReload,
        fetchArguments: fetchArguments,
      ).where((r) => r.isNotLoading).first;

  Future<void> invalidate(K key, {bool forceReload = true}) async {
    final resource = await _ensureResource(key);
    return resource.invalidate(forceReload);
  }

  Future<void> updateValue(K key, V? Function(V? value) changeValue,
      {bool notifyOnNull = false}) async {
    final resource = await _ensureResource(key);
    return resource.updateValue(changeValue, notifyOnNull: notifyOnNull);
  }

  /// Return cached value.
  ///
  /// Pass [sync] false to access cached value without sync by lock.
  Future<V?> getCachedValue(K key, {bool sync = true}) async {
    final resource = await _ensureResource(key);
    return resource.getCachedValue(sync: sync);
  }

  Future<void> putValue(K key, V value) async {
    final resource = await _ensureResource(key);
    return resource.putValue(value);
  }

  Future<void> clear([K? key]) => _lock.synchronized(() async {
        if (key != null) {
          await _resources[key]?.close();
          _resources.remove(key);
          await _storage.delete(key);
        } else {
          _resources.forEach((_, res) => res.close());
          _resources.clear();
          await _storage.clear();
        }
      });

  Future<NetworkBoundResource<K, V>> _ensureResource(K key) =>
      _lock.synchronized(() async {
        var resource = _resources[key];
        if (resource == null) {
          resource = NetworkBoundResource<K, V>(
            key,
            _fetch,
            _cacheDurationResolver,
            _storage,
            logger: logger,
          );
          _resources[key] = resource;
        }
        return resource;
      });
}
