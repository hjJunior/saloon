import 'dart:async';

import 'package:saloon/saloon.dart';

abstract class RequestInterceptor {
  FutureOr<void> onRequest(PendingRequest pendingRequest) => pendingRequest;
  FutureOr<Response> onResponse(Response response) => response;
}
