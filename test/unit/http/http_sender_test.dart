import 'dart:io';

import 'package:cupertino_http/cupertino_http.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:saloon/saloon.dart';

void main() {
  group('HttpSender', () {
    test('defaults to the platform-appropriate client', () {
      final sender = HttpSender();

      if (Platform.isIOS || Platform.isMacOS) {
        expect(sender.client, isA<CupertinoClient>());
      } else {
        expect(sender.client, isA<http.Client>());
        expect(sender.client, isNot(isA<CupertinoClient>()));
      }
    });

    test('uses a provided client instead of the default one', () {
      final customClient = http.Client();
      final sender = HttpSender(customClient);

      expect(sender.client, same(customClient));
    });
  });
}
