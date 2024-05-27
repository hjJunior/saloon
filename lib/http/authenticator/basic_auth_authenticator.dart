import 'dart:convert';

import 'package:saloon/contracts/authenticator.dart';
import 'package:saloon/http/pending_request.dart';

class BasicAuthAuthenticator extends Authentificator {
  final String _username;
  final String _password;

  BasicAuthAuthenticator({required String username, required String password})
      : _username = username,
        _password = password;

  @override
  Future<PendingRequest> set(PendingRequest pendingRequest) async {
    pendingRequest.headers.addAll({'Authorization': _authorization});

    return pendingRequest;
  }

  String get _authorization {
    final bytes = utf8.encode("$_username:$_password");
    return base64.encode(bytes);
  }
}
