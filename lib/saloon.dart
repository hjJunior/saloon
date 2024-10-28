library saloon;

import 'package:saloon/contracts/sender.dart';
import 'package:saloon/faking/mock_client.dart';

import 'senders/http/http_sender.dart';

export 'authenticators/index.dart';
export 'contracts/index.dart';
export 'enums/index.dart';
export 'faking/index.dart';
export 'senders/index.dart';
export 'connector.dart';
export 'pending_request.dart';
export 'request.dart';
export 'response.dart';
export 'types.dart';

class Saloon {
  static MockClient? mockClient;
  static Sender sender = HttpSender();
}
