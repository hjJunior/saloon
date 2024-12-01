import 'package:flutter_test/flutter_test.dart';
import 'package:saloon/contracts/request_interceptor.dart';
import 'package:saloon/saloon.dart';

import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
@GenerateNiceMocks([
  MockSpec<RequestInterceptor>(),
  MockSpec<HttpSender>(),
])
import 'pending_request_dispatcher_test.mocks.dart';

class CustomConnector extends Connector {
  final interceptor = MockRequestInterceptor();

  @override
  Future<String> resolveBaseUrl() async => 'https://example.api/';

  @override
  Future<List<RequestInterceptor>> interceptors() async {
    return [interceptor];
  }
}

class CustomRequest extends Request {
  final interceptor = MockRequestInterceptor();

  @override
  Future<Method> resolveMethod() async => Method.post;

  @override
  Future<String> resolveEndpoint() async => "/users";

  @override
  Future<List<RequestInterceptor>> interceptors() async {
    return [interceptor];
  }
}

void main() {
  setUp(() {
    Saloon.mockClient = null;
  });

  test('can use interceptors when using Mock', () async {
    final response = Response('hello');
    final response2 = Response('world');
    final connector = CustomConnector();
    final request = CustomRequest();

    MockClient([
      MockResponse(request: CustomRequest, response: response),
    ]);

    when(connector.interceptor.onResponse(response))
        .thenAnswer((_) async => response2);

    final pendingRequest = PendingRequest(
      connector: connector,
      request: request,
    );

    await Saloon.dispatcher.dispatch(pendingRequest);

    verifyInOrder([
      connector.interceptor.onRequest(pendingRequest),
      request.interceptor.onRequest(pendingRequest),
      connector.interceptor.onResponse(response),
      // this will assert that the connector interceptor changed the request
      request.interceptor.onResponse(response2),
    ]);
  });

  test('can use interceptors when not using Mock', () async {
    final sender = MockHttpSender();
    final response = Response('hello');
    final response2 = Response('world');
    final connector = CustomConnector();
    final request = CustomRequest();

    when(sender.send(any)).thenAnswer((_) async => response);

    when(connector.interceptor.onResponse(response))
        .thenAnswer((_) async => response2);

    final pendingRequest = PendingRequest(
      connector: connector,
      request: request,
    );

    Saloon.sender = sender;

    await Saloon.dispatcher.dispatch(pendingRequest);

    verifyInOrder([
      connector.interceptor.onRequest(pendingRequest),
      request.interceptor.onRequest(pendingRequest),
      connector.interceptor.onResponse(response),
      // this will assert that the connector interceptor changed the request
      request.interceptor.onResponse(response2),
    ]);
  });
}
