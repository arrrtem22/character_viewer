import 'package:cached_repository/cache/cache.dart';
import 'package:synchronized/synchronized.dart';

class MemoryCacheStorage<K, V> implements CacheStorage<K, V> {
  MemoryCacheStorage(this._cacheName);

  static final _lock = Lock();
  static final Map<String, Map> _cache = {};

  final String _cacheName;

  @override
  Future<void> ensureInitialized() => Future.value();

  static Future<void> clearAll() async => _cache.clear();

  Future<Map<K, CacheEntry<V>>> _ensureCache() => _lock.synchronized(() async {
        Map? cacheBox = _cache[_cacheName];
        if (cacheBox == null) {
          cacheBox = <K, CacheEntry<V>>{};
          _cache[_cacheName] = cacheBox;
        }
        return cacheBox as Map<K, CacheEntry<V>>;
      });

  @override
  Future<void> clear() => _ensureCache().then((box) => box.clear());

  @override
  Future<CacheEntry<V>?> get(K key) async {
    return (await _ensureCache())[key];
  }

  @override
  Future<void> put(K key, V data, {int? storeTime}) async {
    final cacheBox = await _ensureCache();
    cacheBox[key] = CacheEntry(
      data,
      storeTime: storeTime ?? DateTime.now().millisecondsSinceEpoch,
    );
  }

  @override
  Future<void> delete(K key) async {
    (await _ensureCache()).remove(key);
  }

  @override
  String toString() => 'SimpleMemoryCacheStorage($_cacheName)';
}
