import 'package:flutter_test/flutter_test.dart';

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

class ApiConnector extends Connector {
  @override
  Future<String> resolveBaseUrl() async {
    return "https://jsonplaceholder.typicode.com/";
  }

  @override
  Future<Authenticator?> resolveAuthenticator() async {
    return TokenAuthenticator('FakeToken');
  }
}

class CustomRequest extends Request
    implements HasBody<JsonBody>, HasDTOParser<Post> {
  @override
  Future<Method> resolveMethod() async => Method.get;

  @override
  Future<String> resolveEndpoint() async => "/posts/1";

  @override
  Future<JsonBody> resolveBody() async {
    return JsonBody({});
  }

  @override
  Post parseDTO(Response response) {
    return Post.fromJson(response.object());
  }
}

void main() {
  test('can use mock client', () async {
    final client = MockClient([
      await MockResponse.fromFixture(
        "fixtures/my-fixture.json",
        request: CustomRequest,
      ),
    ]);

    final connector = ApiConnector();
    final response = await connector.send(CustomRequest());

    final model = response.asDTO<Post>();

    expect(response.status, 200);
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
