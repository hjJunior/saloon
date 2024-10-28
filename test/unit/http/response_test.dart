import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:saloon/saloon.dart';

@GenerateNiceMocks([
  MockSpec<PendingRequest>(),
  MockSpec<RequestWithDto>(),
])
import 'response_test.mocks.dart';

abstract class RequestWithDto implements HasDTOParser {}

void main() {
  group('.asDTO', () {
    test("throws error when no dto parser contract", () {
      final response = Response(
        'fake-response',
        pendingRequest: MockPendingRequest(),
      );

      expect(
        () => response.asDTO(),
        throwsA("No DTO setup for the request"),
      );
    });

    test("parse DTO from request", () async {
      final pendingRequest = MockPendingRequest();
      final request = MockRequestWithDto();

      when(pendingRequest.request).thenReturn(request);
      when(request.parseDTO(any)).thenReturn('fake-dto');

      final response = Response(
        'fake-response',
        pendingRequest: pendingRequest,
      );

      expect(response.asDTO(), 'fake-dto');
    });
  });

  group('failed and success', () {
    test("when failed status", () {
      final failedStatus = [
        400,
        401,
        402,
        403,
        404,
        405,
        422,
        500,
        501,
        502,
        503
      ];

      for (final status in failedStatus) {
        final response = Response('fake-body', status: status);

        expect(response.failed, true);
        expect(response.success, false);
      }
    });

    test("when success status", () {
      final successStatus = [201, 202, 203];

      for (final status in successStatus) {
        final response = Response('fake-body', status: status);

        expect(response.failed, false);
        expect(response.success, true);
      }
    });
  });

  group('.object', () {
    test("can decode json object", () {
      final response = Response('{ "id": 1 }');

      expect(response.object(), {"id": 1});
    });
  });

  group('.collect', () {
    test("can decode arrays", () {
      final response = Response('[1, 2]');

      expect(response.collect(), [1, 2]);
    });
  });
}
