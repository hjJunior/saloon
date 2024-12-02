import 'dart:async';

import 'package:saloon/saloon.dart';

class CacheFirstPolicy extends CacheablePolicy {
  @override
  Future<Response> handle(PendingRequest pendingRequest) async {
    final cached = await tryGetFromCache(pendingRequest);

    if (cached != null) {
      return cached;
    }

    final response = await Saloon.dispatcher.dispatch(pendingRequest);
    await updateCache(response);

    return response;
  }
}
