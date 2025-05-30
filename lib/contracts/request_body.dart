import 'dart:io';
import 'dart:typed_data';

sealed class RequestBody {}

final class FormBody implements RequestBody {
  final Map<String, String> fields;

  FormBody(this.fields);
}

final class JsonBody implements RequestBody {
  final Map<String, dynamic> json;

  JsonBody(this.json);
}

final class MultipartBody implements RequestBody {
  final Map<String, String> fields;
  final Map<String, File> files;

  MultipartBody({
    this.fields = const {},
    this.files = const {},
  });
}

final class BinaryBody implements RequestBody {
  final Uint8List bytes;

  BinaryBody(this.bytes);
}
