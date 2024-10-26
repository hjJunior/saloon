import 'dart:convert';

import 'package:saloon/contracts/has_dto_parser.dart';
import 'package:saloon/http/pending_request.dart';
import 'package:saloon/saloon.dart';

class Response {
  PendingRequest? pendingRequest;
  final String body;
  final int status;
  final Headers headers;

  Response(
    this.body, {
    this.status = 200,
    this.headers = const {},
    this.pendingRequest,
  });

  T asDTO<T>() {
    final request = pendingRequest?.request;

    if (request is! HasDTOParser<T>) {
      throw "No DTO setup for the request";
    }

    return request.parseDTO(this);
  }

  JsonObject json() {
    return jsonDecode(body);
  }

  List<T> collect<T>() {
    return (jsonDecode(body) as List).cast<T>();
  }

  bool get failed => status < 200 || status >= 400;

  bool get success => !failed;
}
