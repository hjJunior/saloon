## 0.0.2

* `HttpSender` now defaults to a `cupertino_http` (`CupertinoClient`) HTTP client on iOS/macOS, using the native `NSURLSession` stack instead of the plain `http` client. Other platforms are unaffected; passing a custom `http.Client` to `HttpSender` still overrides this default.

## 0.0.1

* TODO: Describe initial release.
