import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:saloon/saloon.dart';

import '../../models/post_model.dart';
import '../../placeholder_connector.dart';

class GetPostRequest extends Request
    implements HasDTOParser<PostModel>, CacheableRequest {
  @override
  FutureOr<String> resolveEndpoint() => "/posts/1";

  @override
  FutureOr<Method> resolveMethod() => Method.get;

  @override
  PostModel parseDTO(Response response) {
    return PostModel.fromJson(response.object());
  }

  @override
  CacheablePolicy get cachePolicy => CacheFirstPolicy();
}

void main() {
  test('testing cache', () async {
    final client = MockClient([
      await MockResponse.fromFixture(
        "fixtures/post.json",
        request: GetPostRequest,
      )
    ]);

    final connector = PlaceholderConnector();
    final response = await connector.send(GetPostRequest());

    final response2 = await connector.send(GetPostRequest());
    expect(response2.status, response.status);

    final cachaeableResponse =
        Saloon.cacheableStorage.get('PlaceholderConnector:GetPostRequest');

    expect(cachaeableResponse, isNotNull);

    client.assertSentCount(1);
  });
}
