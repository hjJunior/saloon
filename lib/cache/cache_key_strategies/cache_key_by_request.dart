import 'dart:async';

import 'package:saloon/saloon.dart';

class CacheKeyByRequest implements CacheKeyGenerator {
  @override
  FutureOr<String> getCacheKey(PendingRequest pendingRequest) {
    return "${pendingRequest.connector.runtimeType}:${pendingRequest.request.runtimeType}";
  }
}
