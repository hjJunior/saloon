import 'dart:convert';
import 'dart:io';

import 'package:saloon/saloon.dart';

typedef MockResponseWhen = bool Function(PendingRequest pending);

class MockResponse {
  final Type request;
  final Response response;
  final MockResponseWhen? when;

  MockResponse({
    required this.request,
    required this.response,
    this.when,
  });

  static Future<MockResponse> fromFixture(
    String path, {
    required Type request,
    MockResponseWhen? when,
  }) async {
    final fixture = await File(path).readAsString();
    final json = jsonDecode(fixture);

    final response = json['body'] is Map
        ? jsonEncode(json['body'])
        : json['body'].toString();

    return MockResponse(
      request: request,
      when: when,
      response: Response(
        response,
        headers: (json['headers'] as Map).cast(),
        status: json['statusCode'] ?? 200,
      ),
    );
  }
}
