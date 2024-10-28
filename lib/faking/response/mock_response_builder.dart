import 'package:saloon/saloon.dart';

class MockResponseBuilder {
  static Response build(
    MockResponse mockResponse,
    PendingRequest pendingRequest,
  ) {
    final response = mockResponse.response;
    response.pendingRequest = pendingRequest;

    return response;
  }
}
