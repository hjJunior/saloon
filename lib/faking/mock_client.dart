import 'package:saloon/faking/response/mock_response_builder.dart';
import 'package:saloon/faking/mocked_call.dart';
import 'package:saloon/faking/testing/mock_testing.dart';
import 'package:saloon/saloon.dart';

class MockClient with MockTesting {
  final List<MockResponse> mockResponses;
  final List<MockedCall> _calls = [];

  MockClient(this.mockResponses) {
    Saloon.mockClient = this;
  }

  @override
  List<MockedCall> get calls => _calls;

  Response guessNextResponse(PendingRequest pendingRequest) {
    final mockResponse = _getNextFromSequence(pendingRequest);

    _calls.add(MockedCall(
      mockResponse: mockResponse,
      pendingRequest: pendingRequest,
    ));

    return MockResponseBuilder.build(mockResponse, pendingRequest);
  }

  MockResponse _getNextFromSequence(PendingRequest pendingRequest) {
    final requestType = pendingRequest.request.runtimeType;
    final index = mockResponses.indexWhere((response) {
      return response.request == requestType;
    });

    if (index == -1) {
      throw "No mock response for '$requestType', this might happen when the code performs more calls than mocked responses";
    }

    final response = mockResponses[index];
    mockResponses.removeAt(index);

    return response;
  }
}
