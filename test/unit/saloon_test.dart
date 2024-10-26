import 'package:flutter_test/flutter_test.dart';
import 'package:saloon/contracts/sender.dart';
import 'package:saloon/http/pending_request.dart';
import 'package:saloon/saloon.dart';

class CustomSender implements Sender {
  @override
  Future<Response> send(PendingRequest pendingRequest) {
    throw UnimplementedError();
  }
}

void main() {
  group('sender', () {
    test("can setup custom sender", () {
      Saloon.sender = CustomSender();

      expect(Saloon.sender, isA<CustomSender>());
    });
  });
}
