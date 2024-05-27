import 'package:saloon/saloon.dart';

abstract class HasDTOParser<T> extends Request {
  T parseDTO(Response response);
}
