import 'package:saloon/saloon.dart';

abstract class HasBodyFiles extends Request {
  Future<Files> resolveBodyFiles();
}
