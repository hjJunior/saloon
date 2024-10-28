import 'package:saloon/saloon.dart';

abstract class Connector {
  Future<Authenticator?> resolveAuthenticator() async => null;

  Future<String> resolveBaseUrl();

  Future<Headers> defaultHeaders() async {
    return {};
  }

  Future<Response> send(Request request) async {
    final pendingRequest = PendingRequest(connector: this, request: request);
    await pendingRequest.build();

    final mockClient = Saloon.mockClient;

    if (mockClient != null) {
      return mockClient.guessNextResponse(pendingRequest);
    }

    return await Saloon.sender.send(pendingRequest);
  }
}
