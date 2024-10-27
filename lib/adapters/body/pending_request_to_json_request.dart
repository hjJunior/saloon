import 'package:http/http.dart' as http;
import 'package:saloon/contracts/request_body.dart';
import 'package:saloon/http/pending_request.dart';

class JsonBodyToMultipartRequest {
  final PendingRequest pendingRequest;

  JsonBodyToMultipartRequest(this.pendingRequest);

  Future<http.BaseRequest> map() async {
    final body = pendingRequest.body;

    if (body is! JsonBody) {
      throw 'PendingRequest must have a body of type JsonBody';
    }

    return http.Request(
      pendingRequest.method.name,
      pendingRequest.uri,
    )..body = body.json.toString();
  }
}
