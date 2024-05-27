import 'package:saloon/http/pending_request.dart';
import 'package:saloon/saloon.dart';

abstract class Sender {
  Future<Response> send(PendingRequest pendingRequest);
}
