import 'package:http/http.dart' as http;
import 'package:saloon/saloon.dart';

class BinaryBodyRequestBuilder {
  final PendingRequest pendingRequest;

  BinaryBodyRequestBuilder(this.pendingRequest);

  Future<http.BaseRequest> build() async {
    final body = pendingRequest.body;

    if (body is! BinaryBody) {
      throw 'PendingRequest must have a body of type BinaryBody';
    }

    final request = http.Request(
      pendingRequest.method.name,
      pendingRequest.uri,
    );

    request.headers['Content-Type'] = 'application/octet-stream';

    request.headers.addAll(pendingRequest.headers);

    request.bodyBytes = body.bytes;

    return request;
  }
}
