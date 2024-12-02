import 'dart:async';

import 'package:saloon/saloon.dart';

class InMemoryCache implements CacheableStorage {
  final _cache = {};

  @override
  FutureOr<void> clearAll() {
    _cache.clear();
  }

  @override
  FutureOr<void> delete(String key) {
    _cache.remove(key);
  }

  @override
  FutureOr<String?> get(String key) {
    return _cache.containsKey(key) ? _cache[key] : null;
  }

  @override
  FutureOr<void> set(String key, String data) {
    _cache[key] = data;
  }
}
