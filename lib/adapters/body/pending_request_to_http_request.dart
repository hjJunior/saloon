import 'package:http/http.dart' as http;
import 'package:saloon/adapters/body/pending_request_to_form_request.dart';
import 'package:saloon/adapters/body/pending_request_to_json_request.dart';
import 'package:saloon/adapters/body/pending_request_to_multipart_request.dart';
import 'package:saloon/contracts/request_body.dart';
import 'package:saloon/http/pending_request.dart';

class PendingRequestToHttpRequest {
  final PendingRequest pendingRequest;

  PendingRequestToHttpRequest(this.pendingRequest);

  Future<http.BaseRequest> map() async {
    switch (pendingRequest.body) {
      case JsonBody _:
        return JsonBodyToMultipartRequest(pendingRequest).map();
      case FormBody _:
        return FormBodyToFormRequest(pendingRequest).map();
      case MultipartBody _:
        return MultipartBodyToMultipartRequest(pendingRequest).map();
      default:
        throw 'PendingRequest must have a body of type JsonBody, FormBody or MultipartBody';
    }
  }
}
