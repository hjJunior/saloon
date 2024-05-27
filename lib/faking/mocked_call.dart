import 'package:saloon/faking/mock_response.dart';
import 'package:saloon/http/pending_request.dart';

class MockedCall {
  final MockResponse mockResponse;
  final PendingRequest pendingRequest;

  MockedCall({required this.mockResponse, required this.pendingRequest});
}
