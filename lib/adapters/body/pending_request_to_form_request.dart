import 'package:http/http.dart' as http;
import 'package:saloon/contracts/request_body.dart';
import 'package:saloon/http/pending_request.dart';

class FormBodyToFormRequest {
  final PendingRequest pendingRequest;

  FormBodyToFormRequest(this.pendingRequest);

  Future<http.BaseRequest> map() async {
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
