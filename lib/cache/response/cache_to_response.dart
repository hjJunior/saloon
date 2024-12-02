import 'dart:convert';

import 'package:saloon/saloon.dart';

class CacheToResponse {
  static Response map(String cache, PendingRequest pendingRequest) {
    final object = jsonDecode(cache);

    return Response.fromPendingRequest(
      object['body'],
      status: object['status'] ?? 200,
      headers: (object['headers'] ?? {}).cast<String, String>(),
      pendingRequest: pendingRequest,
    );
  }
}
