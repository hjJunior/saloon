library saloon;

import 'package:saloon/faking/mock_client.dart';

export 'http/connector.dart';
export 'types.dart';
export 'http/request.dart';

class Saloon {
  static MockClient? mockClient;
}
