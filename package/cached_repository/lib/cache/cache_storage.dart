abstract class CacheStorage<K, V> {
  Future<void> ensureInitialized();

  Future<void> clear();

  Future<CacheEntry<V>?> get(K key);

  Future<void> put(K key, V data, {int? storeTime});

  Future<void> delete(K key);
}

class CacheEntry<V> {
  CacheEntry(this.data, {required this.storeTime});

  V data;
  int storeTime;
}
