import 'package:saloon/http/pending_request.dart';

abstract class Authentificator {
  Future<PendingRequest> set(PendingRequest pendingRequest);
}
