import 'package:flutter_test/flutter_test.dart';
import 'package:saloon/cache/response/response_to_cache.dart';
import 'package:saloon/saloon.dart';

import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
@GenerateNiceMocks([
  MockSpec<CacheableStorage>(),
  MockSpec<Sender>(),
])
import 'cache_first_policy_test.mocks.dart';

class CustomConnector extends Connector {
  @override
  Future<String> resolveBaseUrl() async => 'https://example.api/';
}

class CustomRequest extends Request implements CacheableRequest {
  @override
  Future<Method> resolveMethod() async => Method.post;

  @override
  Future<String> resolveEndpoint() async => "/users";

  @override
  CacheablePolicy get cachePolicy => CacheFirstPolicy();
}

void main() {
  late MockSender mockSender;
  late MockCacheableStorage mockCacheableStorage;
  late CustomConnector connector;
  late CustomRequest request;

  setUp(() {
    mockSender = MockSender();
    mockCacheableStorage = MockCacheableStorage();

    Saloon.sender = mockSender;
    Saloon.cacheableStorage = mockCacheableStorage;

    connector = CustomConnector();
    request = CustomRequest();

    when(mockSender.send(any)).thenAnswer(
      (_) async => Response.fromPendingRequest(
        'network response',
        pendingRequest: PendingRequest(connector: connector, request: request),
      ),
    );
  });

  test('returns cached response if available', () async {
    when(mockCacheableStorage.get(any)).thenAnswer(
      (_) async => ResponseToCache.map(Response('cached response')),
    );

    final response = await connector.send(request);

    expect(response.body, 'cached response');

    verifyNever(mockSender.send(any));
  });

  test('fetches from network if cache is empty', () async {
    when(mockCacheableStorage.get(any)).thenAnswer(
      (_) async => null,
    );

    final response = await connector.send(request);

    expect(response.body, 'network response');

    verify(mockSender.send(any)).called(1);
  });
}
