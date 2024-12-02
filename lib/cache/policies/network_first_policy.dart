import 'dart:async';

import 'package:saloon/saloon.dart';

class NetworkFirstPolicy extends CacheablePolicy {
  @override
  Future<Response> handle(PendingRequest pendingRequest) async {
    try {
      final response = await Saloon.dispatcher.dispatch(pendingRequest);
      await updateCache(response);

      return response;
    } catch (e) {
      final response = await tryGetFromCache(pendingRequest);

      if (response != null) {
        return response;
      }

      rethrow;
    }
  }
}
