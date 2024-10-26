import 'package:flutter_test/flutter_test.dart';
import 'package:saloon/contracts/authenticator.dart';
import 'package:saloon/enums/method.dart';
import 'package:saloon/http/authenticator/token_authenticator.dart';
import 'package:saloon/http/pending_request.dart';
import 'package:saloon/saloon.dart';

class CustomConnector extends Connector {
  @override
  Future<String> resolveBaseUrl() async => 'https://example.api/';

  @override
  Future<Authentificator?> resolveAuthentificator() async {
    return TokenAuthenticator('token');
  }
}

class CustomRequest extends Request implements HasBody<JsonObject> {
  @override
  Future<Method> resolveMethod() async => Method.post;

  @override
  Future<String> resolveEndpoint() async => "/users";

  @override
  Future<JsonObject> resolveBody() async {
    return {
      'int_field': 1,
      'boolean_field': true,
      'string_field': "String content",
      "array_field": [1, 2],
    };
  }

  @override
  Future<Headers> resolveHeaders() async {
    return {'custom': 'headers'};
  }
}

void main() {
  test('can build', () async {
    final subject = await PendingRequest(
      connector: CustomConnector(),
      request: CustomRequest(),
    ).build();

    expect(subject.body, {
      'int_field': 1,
      'boolean_field': true,
      'string_field': "String content",
      "array_field": [1, 2],
    });

    expect(subject.method, Method.post);
    expect(subject.url, 'https://example.api/users');
    expect(subject.headers, {
      'custom': 'headers',
      'Authorization': 'Bearer token',
    });
  });
}
