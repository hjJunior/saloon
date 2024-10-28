import 'package:http/http.dart' as http;
import 'package:saloon/saloon.dart';
import 'package:saloon/senders/http/request/request_builder.dart';
import 'package:saloon/senders/http/response/streamed_response_to_response.dart';

class HttpSender implements Sender {
  final http.Client client;

  HttpSender([http.Client? client]) : client = client ?? http.Client();

  @override
  Future<Response> send(PendingRequest pendingRequest) async {
    final request = await RequestBuilder(pendingRequest).build();
    final streamedResponse = await client.send(request);

    return StreamedResponseToResponse.map(
      streamedResponse,
      pendingRequest,
    );
  }
}
