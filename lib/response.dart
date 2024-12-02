import 'dart:convert';

import 'package:saloon/saloon.dart';

class Response {
  late PendingRequest pendingRequest;
  final String body;
  final int status;
  final Headers headers;

  Response(
    this.body, {
    this.status = 200,
    this.headers = const {},
  });

  factory Response.fromPendingRequest(
    String body, {
    int status = 200,
    Headers headers = const {},
    required PendingRequest pendingRequest,
  }) {
    final response = Response(
      body,
      status: status,
      headers: headers,
    );

    response.pendingRequest = pendingRequest;

    return response;
  }

  T asDTO<T>() {
    final request = pendingRequest.request;

    if (request is! HasDTOParser) {
      throw "No DTO setup for the request";
    }

    return request.parseDTO(this);
  }

  T throwOrDTO<T>() {
    if (failed) {
      throw "Request failed with status $status";
    }

    return asDTO<T>();
  }

  JsonObject object() {
    return jsonDecode(body);
  }

  List<T> collect<T>() {
    return (jsonDecode(body) as List).cast<T>();
  }

  bool get failed => status < 200 || status >= 400;

  bool get success => !failed;
}
