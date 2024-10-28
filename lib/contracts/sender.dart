import 'package:saloon/saloon.dart';

abstract class Sender {
  Future<Response> send(PendingRequest pendingRequest);
}
