import 'package:http/http.dart' as http;
import 'package:saloon/http/pending_request.dart';
import 'package:saloon/http/response.dart';

class StreamedResponseToResponse {
  static Future<Response> map(
    http.StreamedResponse streamedResponse,
    PendingRequest pendingRequest,
  ) async {
    final httpResponse = await http.Response.fromStream(streamedResponse);

    return Response(
      statusCode: httpResponse.statusCode,
      headers: httpResponse.headers,
      body: httpResponse.body,
      pendingRequest: pendingRequest,
    );
  }
}
