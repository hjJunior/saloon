import 'dart:async';

import 'package:saloon/saloon.dart';

abstract class Connector {
  FutureOr<Authenticator?> resolveAuthenticator() async => null;

  FutureOr<String> resolveBaseUrl();

  FutureOr<Headers> defaultHeaders() async {
    return {};
  }

  FutureOr<Response> send(Request request) async {
    final pendingRequest = PendingRequest(connector: this, request: request);
    await pendingRequest.build();

    final mockClient = Saloon.mockClient;

    if (mockClient != null) {
      return mockClient.guessNextResponse(pendingRequest);
    }

    return await Saloon.sender.send(pendingRequest);
  }
}
