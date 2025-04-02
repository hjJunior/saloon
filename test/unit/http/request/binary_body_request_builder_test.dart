import 'dart:async';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:saloon/saloon.dart';
import 'package:saloon/senders/http/request/binary_body_request_builder.dart';
import 'package:http/http.dart' as http;

Future<File> _createTempBinaryFile() async {
  final tempDir = Directory.systemTemp;
  final tempFile = File('${tempDir.path}/test-binary-file.bin');

  await tempFile.writeAsBytes([0, 1, 2, 3, 4]);
  return tempFile;
}

Future<File> _createTempTextFile() async {
  final tempDir = Directory.systemTemp;
  final tempFile = File('${tempDir.path}/test-text-file.txt');

  await tempFile.writeAsString('File test.');
  return tempFile;
}

class CustomBinaryRequest extends Request implements HasBody<BinaryBody> {
  @override
  Future<Method> resolveMethod() async => Method.post;

  @override
  Future<String> resolveEndpoint() async => "/upload";

  @override
  Future<BinaryBody> resolveBody() async {
    final file = await _createTempBinaryFile();
    return BinaryBody(await file.readAsBytes());
  }
}

class OverridesContentTypeRequest extends Request
    implements HasBody<BinaryBody> {
  @override
  Future<Method> resolveMethod() async => Method.post;

  @override
  Future<String> resolveEndpoint() async => "/upload";

  @override
  Future<BinaryBody> resolveBody() async {
    final file = await _createTempTextFile();
    return BinaryBody(await file.readAsBytes());
  }

  @override
  FutureOr<Headers> resolveHeaders() {
    return {'Content-Type': 'text/plain'};
  }
}

class CustomConnector extends Connector {
  @override
  Future<String> resolveBaseUrl() async => 'https://example.api';
}

void main() {
  test('should build request with binary body', () async {
    final pendingRequest = await PendingRequest(
      connector: CustomConnector(),
      request: CustomBinaryRequest(),
    ).build();

    final binaryBuilder = BinaryBodyRequestBuilder(pendingRequest);
    final request = await binaryBuilder.build();

    expect(request, isA<http.Request>());
    expect((request as http.Request).bodyBytes, [0, 1, 2, 3, 4]);
    expect(request.headers['Content-Type'], 'application/octet-stream');
  });

  test('should overrides the content-type', () async {
    final pendingRequest = await PendingRequest(
      connector: CustomConnector(),
      request: OverridesContentTypeRequest(),
    ).build();

    final binaryBuilder = BinaryBodyRequestBuilder(pendingRequest);
    final request = await binaryBuilder.build();

    expect(request.headers['Content-Type'], 'text/plain');
  });
}
