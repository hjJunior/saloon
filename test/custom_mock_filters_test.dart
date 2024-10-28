import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:saloon/saloon.dart';

import 'example/placeholder/placeholder_connector.dart';

class GetPosts extends Request {
  final QueryParams params;

  GetPosts(this.params);

  @override
  FutureOr<String> resolveEndpoint() => "/posts";

  @override
  FutureOr<Method> resolveMethod() => Method.get;

  @override
  FutureOr<QueryParams> resolveQueryParams() => params;
}

void main() {
  test('can use when to filter mocks', () async {
    MockClient([
      MockResponse(
        request: GetPosts,
        response: Response("Posts for author 1"),
        when: (pendingRequest) {
          return pendingRequest.params!['author_id'] == "1";
        },
      ),
      MockResponse(
        request: GetPosts,
        response: Response("Posts for author 2"),
        when: (pendingRequest) {
          return pendingRequest.params!['author_id'] == "2";
        },
      ),
    ]);

    final connector = PlaceholderConnector();
    final author2Response = await connector.send(GetPosts({"author_id": "2"}));
    final author1Response = await connector.send(GetPosts({"author_id": "1"}));

    expect(author1Response.body, "Posts for author 1");
    expect(author2Response.body, "Posts for author 2");
  });
}
