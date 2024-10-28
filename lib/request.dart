import 'dart:async';

import 'package:saloon/contracts/authenticator.dart';
import 'package:saloon/enums/method.dart';
import 'package:saloon/types.dart';

export 'contracts/has_body.dart';

abstract class Request {
  FutureOr<Method> resolveMethod();

  FutureOr<String> resolveEndpoint();

  FutureOr<Authenticator?> resolveAuthentificator() async => null;

  FutureOr<Headers> resolveHeaders() async {
    return {};
  }

  FutureOr<QueryParams> resolveQueryParams() async {
    return {};
  }
}
