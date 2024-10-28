import 'package:http/http.dart' as http;
import 'package:saloon/contracts/request_body.dart';
import 'package:saloon/pending_request.dart';

class FormBodyRequestBuilder {
  final PendingRequest pendingRequest;

  FormBodyRequestBuilder(this.pendingRequest);

  Future<http.BaseRequest> build() async {
    final body = pendingRequest.body;

    if (body is! FormBody) {
      throw 'PendingRequest must have a body of type FormBody';
    }

    return http.Request(
      pendingRequest.method.name,
      pendingRequest.uri,
    )..bodyFields = body.fields;
  }
}