import 'package:flutter_test/flutter_test.dart';
import 'package:saloon/cache/response/response_to_cache.dart';
import 'package:saloon/saloon.dart';

import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
@GenerateNiceMocks([
  MockSpec<CacheableStorage>(),
  MockSpec<Sender>(),
])
import 'network_first_policy_test.mocks.dart';

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
  CacheablePolicy get cachePolicy => NetworkFirstPolicy();
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
  });

  test('returns network response if available', () async {
    when(mockSender.send(any)).thenAnswer(
      (_) async => Response.fromPendingRequest(
        'network response',
        pendingRequest: PendingRequest(connector: connector, request: request),
      ),
    );

    final response = await connector.send(request);

    expect(response.body, 'network response');
    verify(mockSender.send(any)).called(1);
  });

  group('when network fails', () {
    setUp(() {
      when(mockSender.send(any)).thenThrow(Exception('Failed to fetch'));
    });

    test('returns cache response if available', () async {
      when(mockCacheableStorage.get(any)).thenAnswer(
        (_) async => ResponseToCache.map(Response('cached response')),
      );
      final response = await connector.send(request);

      expect(response.body, 'cached response');

      verify(mockSender.send(any)).called(1);
    });

    test('throws network error if cache not available', () async {
      when(mockCacheableStorage.get(any)).thenAnswer((_) async => null);

      await expectLater(() => connector.send(request), throwsException);

      verify(mockSender.send(any)).called(1);
    });
  });
}
