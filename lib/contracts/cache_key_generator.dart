import 'dart:async';

import 'package:saloon/saloon.dart';

abstract class CacheKeyGenerator {
  FutureOr<String> getCacheKey(PendingRequest pendingRequest);
}
