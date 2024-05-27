import 'package:saloon/contracts/authenticator.dart';

import 'package:saloon/http/pending_request.dart';
import 'package:saloon/saloon.dart';

abstract class Connector {
  Future<Authentificator?> resolveAuthentificator() async => null;

  Future<String> resolveBaseUrl();

  Future<Headers> defaultHeaders() async {
    return {};
  }

  Future<T> send<T>(Request request) async {
    final pendingRequest = PendingRequest(connector: this, request: request);
    await pendingRequest.build();

    final mockClient = Saloon.mockClient;

    if (mockClient != null) {
      return mockClient.guessNextResponse(pendingRequest);
    }

    return Future.value();
  }
}
