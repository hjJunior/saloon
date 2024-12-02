import 'dart:async';

import 'package:saloon/saloon.dart';

class CacheKeyByUrl implements CacheKeyGenerator {
  @override
  FutureOr<String> getCacheKey(PendingRequest pendingRequest) {
    return pendingRequest.url;
  }
}
