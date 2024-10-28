import 'dart:async';

import 'package:saloon/saloon.dart';

class PlaceholderConnector extends Connector {
  @override
  FutureOr<String> resolveBaseUrl() => "https://jsonplaceholder.typicode.com";
}
