import 'package:saloon/adapters/mock_response_to_response.dart';
import 'package:saloon/faking/mock_response.dart';
import 'package:saloon/faking/mocked_call.dart';
import 'package:saloon/http/pending_request.dart';
import 'package:saloon/saloon.dart';

class MockClient {
  final List<MockResponse> mockResponses;
  final List<MockedCall> _calls = [];

  MockClient(this.mockResponses) {
    Saloon.mockClient = this;
  }

  Response guessNextResponse(PendingRequest pendingRequest) {
    final mockResponse = _getNextFromSequence(pendingRequest);

    _calls.add(MockedCall(
      mockResponse: mockResponse,
      pendingRequest: pendingRequest,
    ));

    return MockResponseToResponse.map(mockResponse, pendingRequest);
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

  void assertSent(
    Type request, {
    bool Function(PendingRequest)? matcher,
    int? callNumber,
  }) {
    if (callNumber != null) {
      final call = _calls.elementAtOrNull(callNumber - 1);

      if (call == null) {
        throw "No request calls found at $callNumber call number";
      }

      if (call.mockResponse.request != request) {
        throw "Expected request of type '$request' at call number $callNumber, but received '${call.mockResponse.request}'";
      }

      if (matcher == null) {
        return;
      }

      if (!matcher(call.pendingRequest)) {
        throw "Custom matcher failed";
      }

      return;
    }

    final callIndex = _calls.indexWhere((call) {
      return call.mockResponse.request == request;
    });

    if (callIndex == -1) {
      throw "Request $request not sent";
    }

    if (matcher == null) {
      return;
    }

    if (!matcher(_calls[callIndex].pendingRequest)) {
      throw "Custom matcher failed";
    }
  }

  void assertSentCount(int count, [Type? request]) {
    final callsCount = request == null
        ? _calls.length
        : _calls.where((call) {
            return call.mockResponse.request == request;
          }).length;

    if (callsCount != count) {
      throw "Expected $count calls and $callsCount received";
    }
  }
}
