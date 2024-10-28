import 'package:saloon/faking/mocked_call.dart';
import 'package:saloon/pending_request.dart';

mixin MockTesting {
  List<MockedCall> get calls;

  void assertSent(
    Type request, {
    bool Function(PendingRequest)? matcher,
    int? callNumber,
  }) {
    if (callNumber != null) {
      final call = calls.elementAtOrNull(callNumber - 1);

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

    final callIndex = calls.indexWhere((call) {
      return call.mockResponse.request == request;
    });

    if (callIndex == -1) {
      throw "Request $request not sent";
    }

    if (matcher == null) {
      return;
    }

    if (!matcher(calls[callIndex].pendingRequest)) {
      throw "Custom matcher failed";
    }
  }

  void assertSentCount(int count, [Type? request]) {
    final callsCount = request == null
        ? calls.length
        : calls.where((call) {
            return call.mockResponse.request == request;
          }).length;

    if (callsCount != count) {
      throw "Expected $count calls and $callsCount received";
    }
  }
}
