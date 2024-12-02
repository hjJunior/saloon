library saloon;

import 'package:saloon/cache/cache_key_strategies/cache_key_by_request.dart';
import 'package:saloon/cache/storage/in_memory_cache.dart';
import 'package:saloon/contracts/index.dart';
import 'package:saloon/faking/mock_client.dart';
import 'package:saloon/pending_request_dispatcher.dart';

import 'senders/http/http_sender.dart';

export 'authenticators/index.dart';
export 'cache/index.dart';
export 'contracts/index.dart';
export 'enums/index.dart';
export 'faking/index.dart';
export 'senders/index.dart';
export 'connector.dart';
export 'pending_request.dart';
export 'request.dart';
export 'response.dart';
export 'types.dart';

class Saloon {
  static MockClient? mockClient;
  static Sender sender = HttpSender();
  static PendingRequestDispatcher dispatcher = PendingRequestDispatcher();
  static CacheableStorage cacheableStorage = InMemoryCache();
  static CacheKeyGenerator cacheKeyGenerator = CacheKeyByRequest();
}
