import 'dart:async';

import 'package:saloon/cache/response/cache_to_response.dart';
import 'package:saloon/cache/response/response_to_cache.dart';
import 'package:saloon/saloon.dart';

abstract class CacheablePolicy {
  late final storage = Saloon.cacheableStorage;
  late final cacheKeyGenerator = Saloon.cacheKeyGenerator;

  FutureOr<Response> handle(PendingRequest pendingRequest);

  Future<void> updateCache(Response response) async {
    final key = await _getCacheKey(response.pendingRequest);

    await storage.set(key, ResponseToCache.map(response));
  }

  FutureOr<Response?> tryGetFromCache(PendingRequest pendingRequest) async {
    final key = await _getCacheKey(pendingRequest);
    final cachedResponse = await storage.get(key);

    if (cachedResponse == null) {
      return null;
    }

    try {
      return CacheToResponse.map(cachedResponse, pendingRequest);
    } catch (e) {
      await storage.delete(key);
      return null;
    }
  }

  FutureOr<String> _getCacheKey(PendingRequest pendingRequest) {
    return cacheKeyGenerator.getCacheKey(pendingRequest);
  }
}
