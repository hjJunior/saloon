// ignore_for_file: avoid_print

import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:saloon/saloon.dart';

import '../../placeholder_connector.dart';

class CreatePostRequest extends Request implements HasBody<JsonBody> {
  final JsonObject payload;

  CreatePostRequest(this.payload);

  @override
  FutureOr<String> resolveEndpoint() => "/posts";

  @override
  FutureOr<Method> resolveMethod() => Method.post;

  @override
  FutureOr<JsonBody> resolveBody() => JsonBody(payload);
}

void main() {
  test('real world request to create post in json placeholder API', () async {
    final connector = PlaceholderConnector();
    final response = await connector.send(CreatePostRequest({
      "userId": 1,
      "title": "Test",
      "body": "Body",
    }));

    print("Status: ${response.status}");
    print("Response: ${response.body}");
  });
}
