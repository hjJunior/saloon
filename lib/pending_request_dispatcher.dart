import 'dart:async';

import 'package:saloon/contracts/request_interceptor.dart';
import 'package:saloon/saloon.dart';

class PendingRequestDispatcher {
  FutureOr<Response> dispatch(PendingRequest pendingRequest) async {
    await pendingRequest.build();

    final interceptors = await _mergeInterceptors(pendingRequest);

    for (final interceptor in interceptors) {
      await interceptor.onRequest(pendingRequest);
    }

    Response response = await _sendRequest(pendingRequest);

    for (final interceptor in interceptors) {
      response = await interceptor.onResponse(response);
    }

    return response;
  }

  FutureOr<Response> _sendRequest(PendingRequest pendingRequest) async {
    final mockClient = Saloon.mockClient;

    if (mockClient != null) {
      return mockClient.guessNextResponse(pendingRequest);
    }

    return await Saloon.sender.send(pendingRequest);
  }

  FutureOr<List<RequestInterceptor>> _mergeInterceptors(
    PendingRequest pendingRequest,
  ) async {
    return [
      ...await pendingRequest.connector.interceptors(),
      ...await pendingRequest.request.interceptors()
    ];
  }
}
