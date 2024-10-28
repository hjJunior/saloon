import 'dart:async';

import 'package:saloon/saloon.dart';

abstract class HasBody<T extends RequestBody> extends Request {
  FutureOr<T> resolveBody();
}
