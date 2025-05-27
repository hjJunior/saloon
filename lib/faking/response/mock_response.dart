import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart' show rootBundle;
import 'package:saloon/faking/response/fixture_type.dart';
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
    FixtureSource source = FixtureSource.file,
    MockResponseWhen? when,
  }) async {
    final fixture = switch (source) {
      FixtureSource.asset => await rootBundle.loadString(path),
      FixtureSource.file => await File(path).readAsString(),
    };

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
