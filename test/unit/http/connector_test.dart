import 'package:flutter_test/flutter_test.dart';
import 'package:saloon/saloon.dart';

class CustomConnector extends Connector {
  @override
  Future<String> resolveBaseUrl() async => 'https://example.api';

  @override
  Future<Authenticator?> resolveAuthenticator() async {
    return TokenAuthenticator('token');
  }
}

class CustomRequest extends Request implements HasBody<JsonBody> {
  @override
  Future<Method> resolveMethod() async => Method.get;

  @override
  Future<String> resolveEndpoint() async => "/users";

  @override
  Future<JsonBody> resolveBody() async {
    return JsonBody({
      'int_field': 1,
      'boolean_field': true,
      'string_field': "String content",
      "array_field": [1, 2],
    });
  }

  @override
  Future<Headers> resolveHeaders() async {
    return {'custom': 'headers'};
  }
}

class CustomSender implements Sender {
  @override
  Future<Response> send(PendingRequest pendingRequest) async {
    expect(pendingRequest.connector, isA<CustomConnector>());
    expect(pendingRequest.request, isA<CustomRequest>());

    final builtResponse = await pendingRequest.build();

    expect(builtResponse.body, isA<JsonBody>());

    expect((builtResponse.body as JsonBody).json, {
      'int_field': 1,
      'boolean_field': true,
      'string_field': "String content",
      "array_field": [1, 2],
    });

    expect(builtResponse.method, Method.get);
    expect(builtResponse.url, 'https://example.api/users');
    expect(builtResponse.headers, {
      'custom': 'headers',
      'Authorization': 'Bearer token',
    });

    return Response('Custom sender');
  }
}

void main() {
  setUp(() {
    Saloon.mockClient = null;
    Saloon.sender = CustomSender();
  });

  group('send', () {
    test('when using mock client', () async {
      MockClient([
        MockResponse(request: CustomRequest, response: Response("Hello World")),
      ]);

      final connector = CustomConnector();
      final response = await connector.send(CustomRequest());

      expect(response.body, 'Hello World');
      expect(response.status, 200);
      expect(response.failed, false);
      expect(response.success, true);
    });

    test("when using custom sender", () async {
      final connector = CustomConnector();
      final response = await connector.send(CustomRequest());

      expect(response.body, 'Custom sender');
      expect(response.status, 200);
      expect(response.failed, false);
      expect(response.success, true);
    });
  });
}
