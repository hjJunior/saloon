import 'package:saloon/contracts/cache_policy.dart';

abstract class CacheableRequest {
  CacheablePolicy get cachePolicy;
}
