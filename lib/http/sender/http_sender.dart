import 'package:http/http.dart' as http;
import 'package:saloon/adapters/pending_request_to_http_request.dart';
import 'package:saloon/adapters/streamed_response_to_response.dart';
import 'package:saloon/contracts/sender.dart';
import 'package:saloon/http/pending_request.dart';
import 'package:saloon/saloon.dart';

class HttpSender implements Sender {
  final http.Client client;

  HttpSender([http.Client? client]) : client = client ?? http.Client();

  @override
  Future<Response> send(PendingRequest pendingRequest) async {
    final request = await PendingRequestToHttpRequest.map(pendingRequest);
    final streamedResponse = await client.send(request);

    return StreamedResponseToResponse.map(
      streamedResponse,
      pendingRequest,
    );
  }
}
