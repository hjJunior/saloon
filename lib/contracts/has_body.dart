import 'package:saloon/saloon.dart';

abstract class HasBody<T> extends Request {
  Future<T> resolveBody();
}
