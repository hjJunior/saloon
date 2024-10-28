import 'package:saloon/contracts/authenticator.dart';
import 'package:saloon/pending_request.dart';

class MultiAuthenticator extends Authenticator {
  final List<Authenticator> authenticators;

  MultiAuthenticator(this.authenticators);

  @override
  Future<PendingRequest> set(PendingRequest pendingRequest) async {
    for (var authenticator in authenticators) {
      pendingRequest = await authenticator.set(pendingRequest);
    }

    return pendingRequest;
  }
}
