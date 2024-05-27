import 'package:saloon/faking/mock_response.dart';
import 'package:saloon/http/pending_request.dart';
import 'package:saloon/saloon.dart';

class MockResponseToResponse {
  static Response map(
    MockResponse mockResponse,
    PendingRequest pendingRequest,
  ) {
    return Response(
      statusCode: mockResponse.statusCode,
      headers: mockResponse.headers,
      body: mockResponse.response,
      pendingRequest: pendingRequest,
    );
  }
}
