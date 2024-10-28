import 'package:saloon/contracts/authenticator.dart';
import 'package:saloon/enums/method.dart';
import 'package:saloon/types.dart';

export 'contracts/has_body.dart';

abstract class Request {
  Future<Method> resolveMethod();

  Future<String> resolveEndpoint();

  Future<Authenticator?> resolveAuthentificator() async => null;

  Future<Headers> resolveHeaders() async {
    return {};
  }

  Future<QueryParams> resolveQueryParams() async {
    return {};
  }
}
