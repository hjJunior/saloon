import 'package:saloon/contracts/has_dto_parser.dart';
import 'package:saloon/http/pending_request.dart';
import 'package:saloon/saloon.dart';

class Response {
  final int statusCode;
  final Headers headers;
  final String body;
  final PendingRequest pendingRequest;

  Response({
    required this.statusCode,
    required this.headers,
    required this.body,
    required this.pendingRequest,
  });

  T asDTO<T>() {
    final request = pendingRequest.request;

    if (request is! HasDTOParser<T>) {
      throw "The response do not support dto";
    }

    return request.parseDTO(this);
  }
}
