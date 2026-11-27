import 'dart:io';

import 'package:cupertino_http/cupertino_http.dart';
import 'package:http/http.dart' as http;
import 'package:saloon/saloon.dart';
import 'package:saloon/senders/http/request/request_builder.dart';
import 'package:saloon/senders/http/response/streamed_response_to_response.dart';

class HttpSender implements Sender {
  final http.Client client;

  HttpSender([http.Client? client]) : client = client ?? _defaultClient();

  /// Uses the native `NSURLSession`-backed client on iOS/macOS so Saloon
  /// gets platform networking features (VPN/proxy awareness, HTTP/2, etc.)
  /// out of the box, falling back to the standard `http` client elsewhere.
  static http.Client _defaultClient() {
    if (Platform.isIOS || Platform.isMacOS) {
      return CupertinoClient.fromSessionConfiguration(
        URLSessionConfiguration.ephemeralSessionConfiguration(),
      );
    }

    return http.Client();
  }

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
