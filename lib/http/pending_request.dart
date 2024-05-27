import 'package:saloon/contracts/authenticator.dart';
import 'package:saloon/enums/method.dart';
import 'package:saloon/saloon.dart';

class PendingRequest {
  final Connector connector;
  final Request request;

  PendingRequest({required this.connector, required this.request});

  late Method method;
  late String url;
  late Body body;
  late Headers headers;

  Future<PendingRequest> build() async {
    // https://stackoverflow.com/questions/66688500/conditional-type-checking-of-dart-does-not-work-as-expected
    final selfRequest = request;

    method = await request.resolveMethod();
    url = await request.resolveEndpoint();
    headers = await request.resolveHeaders();

    if (selfRequest is HasBody) {
      body = await selfRequest.resolveBody();
    }

    final authentificator = await _getAuthentificator();
    if (authentificator != null) {
      await authentificator.set(this);
    }

    return this;
  }

  Future<Authentificator?> _getAuthentificator() async {
    final requestAuth = await request.resolveAuthentificator();

    if (requestAuth != null) {
      return requestAuth;
    }

    return await connector.resolveAuthentificator();
  }
}
