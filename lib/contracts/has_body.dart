import 'package:saloon/contracts/request_body.dart';
import 'package:saloon/saloon.dart';

abstract class HasBody<T extends RequestBody> extends Request {
  Future<T> resolveBody();
}
