import 'dart:async';

import 'package:cached_repository/cache/cache.dart';
import 'package:cached_repository/resource.dart';
import 'package:logger/logger.dart';
import 'package:rxdart/rxdart.dart';
import 'package:synchronized/synchronized.dart';

typedef FetchCallable<K, V> = Future<V> Function(K key, [dynamic arguments]);

class NetworkBoundResource<K, V> {
  NetworkBoundResource(
    this._resourceKey,
    this._fetch,
    this._cacheDurationResolver,
    this._storage, {
    Logger? logger,
  }) : _logger = logger;

  final Logger? _logger;
  final _subject = BehaviorSubject<Resource<V>>();
  final K _resourceKey;
  final FetchCallable<K, V>? _fetch;
  final CacheDurationResolver<K, V> _cacheDurationResolver;
  final CacheStorage<K, V> _storage;

  final _lock = Lock();
  bool _isLoading = false;
  bool _shouldReload = false;

  /// forceReload - reload even if cache is valid
  ///
  /// skipEmptyLoading - skips loading state without resource
  Stream<Resource<V>> load({
    bool forceReload = false,
    bool skipEmptyLoading = false,
    dynamic fetchArguments,
  }) {
    if (!_isLoading) {
      _isLoading = true;
      _lock.synchronized(() async {
        _shouldReload = false;
        // try always starting with loading value
        if (_subject.hasValue || !skipEmptyLoading) {
          // prevent previous SUCCESS to return
          _subject.add(Resource.loading(_subject.valueOrNull?.data));
        }
        await _loadProcess(forceReload, fetchArguments);
      }).then((_) {
        _isLoading = false;
        if (_shouldReload) {
          load(
            forceReload: true,
            skipEmptyLoading: skipEmptyLoading,
          );
        }
      });
    } else if (forceReload) {
      // don't need to call load many times
      // perform another load only once
      _shouldReload = true;
    }
    return _subject;
  }

  Future<void> updateValue(V? Function(V? value) changeValue,
      {bool notifyOnNull = false}) async {
    _lock.synchronized(() async {
      final cached = await _storage.get(_resourceKey);
      final newValue = changeValue.call(cached?.data);

      if (newValue != null) {
        await _storage.put(
          _resourceKey,
          newValue,
          storeTime: cached?.storeTime ?? 0,
        );

        _subject.add(Resource.success(newValue));
      } else if (cached != null) {
        await _storage.delete(_resourceKey);
        if (notifyOnNull) _subject.add(Resource.success(null));
      }
    });
  }

  Future<V?> getCachedValue({bool sync = true}) {
    return sync
        ? _lock.synchronized(() => _getCachedValue())
        : _getCachedValue();
  }

  Future<V?> _getCachedValue() async {
    final cached = await _storage.get(_resourceKey);
    return cached?.data;
  }

  Future<void> _loadProcess(bool forceReload, dynamic fetchArguments) async {
    // get value from cache
    final cached = await _storage.get(_resourceKey);
    if (cached != null && !forceReload) {
      final cacheDuration =
          _cacheDurationResolver(_resourceKey, cached.data).inMilliseconds;

      if (cached.storeTime <
          DateTime.now().millisecondsSinceEpoch - cacheDuration) {
        forceReload = true;
      }
    }

    if (cached != null || _fetch == null) {
      if (forceReload && _fetch != null) {
        final resource = Resource.loading(cached?.data);
        if (_subject.valueOrNull != resource) {
          _subject.add(resource);
        }
      } else {
        final resource = Resource.success(cached?.data);
        if (_subject.valueOrNull != resource) {
          _subject.add(resource);
        }
        return;
      }
    }

    // no need to perform another load while fetch not called yet
    _shouldReload = false;

    // fetch value from network
    return _subject.addStream(_fetch!
        .call(_resourceKey, fetchArguments)
        .asStream()
        .asyncMap((data) async {
          await _storage.put(_resourceKey, data);
          return data;
        })
        .map((data) => Resource.success(data))
        .doOnError((error, trace) {
          _logger?.e(
            'Error loading resource by id $_resourceKey with storage $_storage',
            error,
            trace);
        })
        .onErrorReturnWith((error, trace) => Resource.error(
            'Resource $_resourceKey loading error',
            error: error,
            stackTrace: trace,
            data: cached?.data)));
  }

  Future<void> putValue(V value) async {
    assert(value != null);

    _lock.synchronized(() async {
      await _storage.put(_resourceKey, value);
      _subject.add(Resource.success(value));
    });
  }

  Future<void> _clearCache() async {
    await _storage.ensureInitialized();
    await _storage.delete(_resourceKey);
  }

  Future<void> _overrideStoreTime(int storeTime) async {
    _lock.synchronized(() async {
      final cached = await _storage.get(_resourceKey);
      if (cached != null) {
        await _storage.put(_resourceKey, cached.data, storeTime: storeTime);
      } else {
        await _storage.delete(_resourceKey);
      }
    });
  }

  Future<void> invalidate([bool forceReload = true]) async {
    // don't clear cache for offline usage, just override store time
    await _overrideStoreTime(0);
    if (forceReload) {
      await load(forceReload: true).where((event) => event.isNotLoading).first;
    }
  }

  Future<void> close() async {
    await _clearCache();
    _subject.close();
  }
}

typedef CacheDurationResolver<K, V> = Duration Function(K key, V value);
