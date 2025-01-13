import 'package:http/http.dart' as http;
import 'package:saloon/contracts/request_body.dart';
import 'package:saloon/pending_request.dart';
import 'package:saloon/senders/http/request/base_request_builder.dart';
import 'package:saloon/senders/http/request/form_body_request_builder.dart';
import 'package:saloon/senders/http/request/json_request_request_builder.dart';
import 'package:saloon/senders/http/request/multipart_body_request_builder.dart';

class RequestBuilder {
  final PendingRequest pendingRequest;

  RequestBuilder(this.pendingRequest);

  Future<http.BaseRequest> build() async {
    switch (pendingRequest.body) {
      case JsonBody _:
        return JsonBodyRequestBuilder(pendingRequest).build();
      case FormBody _:
        return FormBodyRequestBuilder(pendingRequest).build();
      case MultipartBody _:
        return MultipartBodyRequestBuilder(pendingRequest).build();
      default:
        return BaseRequestBuilder(pendingRequest).build();
    }
  }
}
