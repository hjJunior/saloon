import 'package:http/http.dart' as http;
import 'package:saloon/http/pending_request.dart';
import 'package:saloon/saloon.dart';

class PendingRequestToHttpRequest {
  static Future<http.BaseRequest> map(PendingRequest pendingRequest) async {
    final uri = Uri.parse(pendingRequest.url);
    uri.replace(queryParameters: pendingRequest.params);

    final request = http.MultipartRequest(pendingRequest.method.name, uri);

    request.fields.addAll(pendingRequest.body.cast<String, String>());
    request.headers.addAll(pendingRequest.headers);
    request.files.addAll(await _getRequestFiles(pendingRequest));

    return request;
  }

  static Future<List<http.MultipartFile>> _getRequestFiles(
    PendingRequest pendingRequest,
  ) async {
    final List<http.MultipartFile> list = [];

    if (pendingRequest is! HasBodyFiles) {
      return list;
    }

    for (var field in pendingRequest.files.keys) {
      final file = await http.MultipartFile.fromPath(
        field,
        pendingRequest.files[field]!.path,
      );

      list.add(file);
    }

    return list;
  }
}
