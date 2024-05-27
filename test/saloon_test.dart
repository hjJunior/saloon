import 'package:flutter_test/flutter_test.dart';
import 'package:saloon/contracts/authenticator.dart';
import 'package:saloon/enums/method.dart';
import 'package:saloon/faking/mock_client.dart';
import 'package:saloon/faking/mock_response.dart';
import 'package:saloon/http/authenticator/token_authenticator.dart';

import 'package:saloon/saloon.dart';

class UataConnector extends Connector {
  @override
  Future<Authentificator?> resolveAuthentificator() async {
    final token = await Future.value('FakeToken');

    return TokenAuthenticator(token: token);
  }
}

class CustomRequest extends Request implements HasBody {
  @override
  Future<Method> resolveMethod() async => Method.GET;

  @override
  Future<String> resolveEndpoint() async => "/oie";

  @override
  Future<Body> resolveBody() async {
    return {};
  }
}

void main() {
  test('adds one to input values', () async {
    final client = MockClient([
      MockResponse(request: CustomRequest, response: "Hello World"),
    ]);

    final connector = UataConnector();
    final response = await connector.send(CustomRequest());

    expect(response, 'Hello World');

    client.assertSent(CustomRequest, matcher: (pendingRequest) {
      expect(pendingRequest.url, "/oie");
      expect(pendingRequest.headers['Authorization'], 'Bearer FakeToken');

      return true;
    });

    client.assertSentCount(1, CustomRequest);
  });
}
