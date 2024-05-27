import 'package:saloon/contracts/authenticator.dart';
import 'package:saloon/http/pending_request.dart';

class HeaderAuthenticator extends Authentificator {
  final String query;
  final String value;

  HeaderAuthenticator(this.query, this.value);

  @override
  Future<PendingRequest> set(PendingRequest pendingRequest) async {
    pendingRequest.headers.addAll({query: value});

    return pendingRequest;
  }
}
