import 'dart:async';

import 'package:saloon/saloon.dart';

class StaleWhileRevalidatePolicy extends CacheablePolicy {
  @override
  Future<Response> handle(PendingRequest pendingRequest) async {
    final cached = await tryGetFromCache(pendingRequest);

    if (cached != null) {
      // dispatch revalidate request without awaiting for it
      _revalidate(pendingRequest);

      return cached;
    }

    return await _revalidate(pendingRequest);
  }

  Future<Response> _revalidate(PendingRequest pendingRequest) async {
    final response = await Saloon.dispatcher.dispatch(pendingRequest);
    await updateCache(response);

    return response;
  }
}
