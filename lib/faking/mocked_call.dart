import 'package:saloon/faking/response/mock_response.dart';
import 'package:saloon/pending_request.dart';

class MockedCall {
  final MockResponse mockResponse;
  final PendingRequest pendingRequest;

  MockedCall({required this.mockResponse, required this.pendingRequest});
}
