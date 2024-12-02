import 'dart:async';

abstract class CacheableStorage {
  FutureOr<void> set(String key, String data);
  FutureOr<String?> get(String key);
  FutureOr<void> delete(String key);
  FutureOr<void> clearAll();
}
