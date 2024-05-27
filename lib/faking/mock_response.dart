import 'dart:convert';
import 'dart:io';

import 'package:saloon/saloon.dart';

class MockResponse {
  final Type request;
  final String response;
  final int statusCode;
  final Headers headers;

  MockResponse({
    required this.request,
    required this.response,
    this.statusCode = 200,
    this.headers = const {},
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
      response: response,
      headers: (json['headers'] as Map).cast(),
      statusCode: json['statusCode'] ?? 200,
    );
  }
}
