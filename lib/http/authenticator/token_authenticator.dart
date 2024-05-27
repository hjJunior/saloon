import 'package:saloon/http/authenticator/header_authenticator.dart';

class TokenAuthenticator extends HeaderAuthenticator {
  TokenAuthenticator(String token, [String type = "Bearer"])
      : super('Authorization', "$type $token");
}
