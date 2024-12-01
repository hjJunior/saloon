import 'dart:async';

import 'package:saloon/contracts/request_interceptor.dart';
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

    return Saloon.dispatcher.dispatch(pendingRequest);
  }
}
