import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:saloon/saloon.dart';

import '../../models/post_model.dart';
import '../../placeholder_connector.dart';

class GetPostsRequest extends Request implements HasDTOParser<List<PostModel>> {
  @override
  FutureOr<String> resolveEndpoint() => "/posts";

  @override
  FutureOr<Method> resolveMethod() => Method.get;

  @override
  List<PostModel> parseDTO(Response response) {
    return response
        .collect()
        .map((item) => PostModel.fromJson(item))
        .toList()
        .cast<PostModel>();
  }
}

void main() {
  test('real world request to get posts in json placeholder API', () async {
    final connector = PlaceholderConnector();
    final response = await connector.send(GetPostsRequest());

    // ignore: avoid_print
    print(response.throwOrDTO<List<PostModel>>());
  });
}
