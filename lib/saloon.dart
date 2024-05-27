library saloon;

import 'package:saloon/contracts/sender.dart';
import 'package:saloon/faking/mock_client.dart';
import 'package:saloon/http/sender/http_sender.dart';

export 'http/connector.dart';
export 'types.dart';
export 'http/request.dart';
export 'http/response.dart';

class Saloon {
  static MockClient? mockClient;
  static Sender sender = HttpSender();
}
