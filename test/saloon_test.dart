import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:saloon/contracts/authenticator.dart';
import 'package:saloon/contracts/has_dto_parser.dart';
import 'package:saloon/enums/method.dart';
import 'package:saloon/faking/mock_client.dart';
import 'package:saloon/faking/mock_response.dart';
import 'package:saloon/http/authenticator/token_authenticator.dart';

import 'package:saloon/saloon.dart';

class Post {
  final num id;
  final String title;
  final String body;

  Post({required this.id, required this.title, required this.body});

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'],
      title: json['title'],
      body: json['body'],
    );
  }
}

class UataConnector extends Connector {
  @override
  Future<String> resolveBaseUrl() async {
    return "https://jsonplaceholder.typicode.com/";
  }

  @override
  Future<Authentificator?> resolveAuthentificator() async {
    return TokenAuthenticator('FakeToken');
  }
}

class CustomRequest extends Request implements HasBody, HasDTOParser<Post> {
  @override
  Future<Method> resolveMethod() async => Method.GET;

  @override
  Future<String> resolveEndpoint() async => "/posts/1";

  @override
  Future<Body> resolveBody() async {
    return {};
  }

  @override
  Post parseDTO(Response response) {
    return Post.fromJson(jsonDecode(response.body));
  }
}

void main() {
  test('adds one to input values', () async {
    final client = MockClient([
      await MockResponse.fromFixture(
        "fixtures/my-fixture.json",
        request: CustomRequest,
      ),
    ]);

    final connector = UataConnector();
    final response = await connector.send(CustomRequest());

    final model = response.asDTO<Post>();

    expect(response.statusCode, 200);
    expect(
      model.title,
      "sunt aut facere repellat provident occaecati excepturi optio reprehenderit",
    );

    client.assertSent(CustomRequest, matcher: (pendingRequest) {
      expect(
        pendingRequest.url,
        "https://jsonplaceholder.typicode.com/posts/1",
      );
      expect(pendingRequest.headers['Authorization'], 'Bearer FakeToken');

      return true;
    });

    client.assertSentCount(1, CustomRequest);
  });
}
