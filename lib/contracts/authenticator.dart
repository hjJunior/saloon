import 'package:saloon/http/pending_request.dart';

abstract class Authenticator {
  Future<PendingRequest> set(PendingRequest pendingRequest);
}
