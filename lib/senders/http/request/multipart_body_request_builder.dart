import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:saloon/contracts/request_body.dart';
import 'package:saloon/pending_request.dart';

class MultipartBodyRequestBuilder {
  final PendingRequest pendingRequest;

  MultipartBodyRequestBuilder(this.pendingRequest);

  Future<http.BaseRequest> build() async {
    final body = pendingRequest.body;

    if (body is! MultipartBody) {
      throw 'PendingRequest must have a body of type MultipartBody';
    }

    final request = http.MultipartRequest(
      pendingRequest.method.name,
      pendingRequest.uri,
    );

    request.fields.addAll(body.fields);
    request.headers.addAll(pendingRequest.headers);
    request.files.addAll(await _getRequestFiles(body.files));

    return request;
  }

  static Future<List<http.MultipartFile>> _getRequestFiles(
    Map<String, File> files,
  ) async {
    final List<http.MultipartFile> list = [];

    for (var field in files.keys) {
      final file = await http.MultipartFile.fromPath(
        field,
        files[field]!.path,
      );

      list.add(file);
    }

    return list;
  }
}
