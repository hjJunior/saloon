import 'package:http/http.dart' as http;
import 'package:saloon/pending_request.dart';
import 'package:saloon/response.dart';

class StreamedResponseToResponse {
  static Future<Response> map(
    http.StreamedResponse streamedResponse,
    PendingRequest pendingRequest,
  ) async {
    final httpResponse = await http.Response.fromStream(streamedResponse);

    return Response(
      httpResponse.body,
      status: httpResponse.statusCode,
      headers: httpResponse.headers,
      pendingRequest: pendingRequest,
    );
  }
}
