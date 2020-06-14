/// This is a performance tweak to avoid unnecessary server fetches.
/// We can cache any object by templating the object here and providing a
/// fetcher which will fetch this object in case it does not exist in the cache.
/// 
/// The user is supposed to manage the life cycle of the cache and invalidate
/// it when necessary.
class Cache<T> {
  Map<String, T> _cache = new Map();

  // async method to fetch resource if it does not exist in cache
  Future<T> Function(String) _fetch;

  Cache(this._fetch);

  Future<T> get(String id) async {
    if (!_cache.containsKey(id)) {
      _cache[id] = await _fetch(id);
    }

    return _cache[id];
  }

  invalidate() {
    _cache = new Map();
  }
}
