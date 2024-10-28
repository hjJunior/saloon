import 'dart:convert';
import 'dart:io';

import 'package:saloon/saloon.dart';

class MockResponse {
  final Type request;
  final Response response;

  MockResponse({
    required this.request,
    required this.response,
  });

  static Future<MockResponse> fromFixture(
    String path, {
    required Type request,
  }) async {
    final fixture = await File(path).readAsString();
    final json = jsonDecode(fixture);

    final response = json['body'] is Map
        ? jsonEncode(json['body'])
        : json['body'].toString();

    return MockResponse(
      request: request,
      response: Response(
        response,
        headers: (json['headers'] as Map).cast(),
        status: json['statusCode'] ?? 200,
      ),
    );
  }
}
