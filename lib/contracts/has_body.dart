import 'package:saloon/saloon.dart';

abstract class HasBody extends Request {
  Future<Body> resolveBody();
}
