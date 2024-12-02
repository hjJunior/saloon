import 'dart:convert';

import 'package:saloon/saloon.dart';

class ResponseToCache {
  static String map(Response response) {
    return jsonEncode({
      "status": response.status,
      "body": response.body,
      "headers": response.headers,
    });
  }
}
