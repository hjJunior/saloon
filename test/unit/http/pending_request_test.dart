import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:saloon/saloon.dart';

class CustomConnector extends Connector {
  @override
  Future<String> resolveBaseUrl() async => 'https://example.api/';

  @override
  Future<Authenticator?> resolveAuthenticator() async {
    return TokenAuthenticator('token');
  }
}

class CustomRequest extends Request implements HasBody<JsonBody> {
  @override
  Future<Method> resolveMethod() async => Method.post;

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

class AbsoluteUrlOverrideRequest extends Request {
  @override
  Future<String> resolveEndpoint() async => "https://custom.api.url";

  @override
  Future<Method> resolveMethod() async => Method.get;
}

class CustomQueryRequest extends Request {
  @override
  Future<String> resolveEndpoint() async => "/users?id=4";

  @override
  Future<Method> resolveMethod() async => Method.get;

  @override
  FutureOr<QueryParams> resolveQueryParams() => {"name": "John"};
}

void main() {
  test('can build', () async {
    final subject = await PendingRequest(
      connector: CustomConnector(),
      request: CustomRequest(),
    ).build();

    expect((subject.body as JsonBody).json, {
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

  test('should override base URL with absolute URL', () async {
    final subject = await PendingRequest(
      connector: CustomConnector(),
      request: AbsoluteUrlOverrideRequest(),
    ).build();

    expect(subject.url, 'https://custom.api.url');
  });

  test('should correctly concatenate query parameters in the URL', () async {
    final subject = await PendingRequest(
      connector: CustomConnector(),
      request: CustomQueryRequest(),
    ).build();

    expect(subject.uri.toString(), 'https://example.api/users?id=4&name=John');
  });
}
