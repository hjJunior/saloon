import 'package:http/http.dart' as http;
import 'package:saloon/pending_request.dart';

class BaseRequestBuilder {
  final PendingRequest pendingRequest;

  BaseRequestBuilder(this.pendingRequest);

  Future<http.BaseRequest> build() async {
    final request = http.Request(
      pendingRequest.method.name,
      pendingRequest.uri,
    );

    pendingRequest.headers.forEach((key, value) {
      request.headers[key] = value;
    });

    return request;
  }
}
