import 'package:saloon/contracts/authenticator.dart';
import 'package:saloon/enums/method.dart';
import 'package:saloon/saloon.dart';
import 'package:url_builder/url_builder.dart';

class PendingRequest {
  final Connector connector;
  final Request request;

  PendingRequest({required this.connector, required this.request});

  late Method method;
  late String url;
  late JsonObject body;
  late Headers headers;
  late Files files;
  late QueryParams params;

  Future<PendingRequest> build() async {
    // https://stackoverflow.com/questions/66688500/conditional-type-checking-of-dart-does-not-work-as-expected
    final selfRequest = request;

    method = await request.resolveMethod();
    url = await _getEndpoint();
    headers = await request.resolveHeaders();
    params = await request.resolveQueryParams();

    if (selfRequest is HasBody) {
      body = await selfRequest.resolveBody();
    }

    if (selfRequest is HasBodyFiles) {
      files = await selfRequest.resolveBodyFiles();
    }

    final authentificator = await _getAuthentificator();
    if (authentificator != null) {
      await authentificator.set(this);
    }

    return this;
  }

  Future<String> _getEndpoint() async {
    final requestEndpoint = await request.resolveEndpoint();
    final connectorBaseuUrl = await connector.resolveBaseUrl();

    return urlJoin(connectorBaseuUrl, requestEndpoint);
  }

  Future<Authentificator?> _getAuthentificator() async {
    final requestAuth = await request.resolveAuthentificator();

    if (requestAuth != null) {
      return requestAuth;
    }

    return await connector.resolveAuthentificator();
  }
}
