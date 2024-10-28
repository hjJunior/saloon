import 'package:saloon/pending_request.dart';

abstract class Authenticator {
  Future<PendingRequest> set(PendingRequest pendingRequest);
}
