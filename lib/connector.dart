import 'dart:async';

import 'package:saloon/saloon.dart';

abstract class Connector {
  FutureOr<Authenticator?> resolveAuthenticator() async => null;

  FutureOr<String> resolveBaseUrl();

  FutureOr<Headers> defaultHeaders() async {
    return {};
  }

  FutureOr<List<RequestInterceptor>> interceptors() async {
    return [];
  }

  FutureOr<Response> send(Request request) async {
    final pendingRequest = PendingRequest(connector: this, request: request);

    if (request is CacheableRequest) {
      final cacheableRequest = request as CacheableRequest;
      return cacheableRequest.cachePolicy.handle(pendingRequest);
    }

    return Saloon.dispatcher.dispatch(pendingRequest);
  }
}
