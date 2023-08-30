import 'dart:io';

import 'package:test/test.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;
import 'package:googleapis_auth/auth_io.dart';
import 'package:watch_fhir/watch_fhir.dart';

class MockHttpClient extends Mock implements http.Client {}

void main() {
  group('getCredentials', () {
    late MockHttpClient mockClient;

    setUp(() {
      mockClient = MockHttpClient();
    });

    test('Obtaining credentials for regular service account', () async {
      final expectedCredentials = AccessCredentials(
        AccessToken(
            'token', 'scope', DateTime.now().add(Duration(hours: 1)).toUtc()),
        null,
        ['scope'],
      );

      when(mockClient.post(
        Uri.parse('https://mayjuun.com/fhir/r4'),
        headers: anyNamed('headers'),
        body: anyNamed('body'),
      )).thenAnswer(
        (_) async => http.Response(
          '{"access_token": "token", "expires_in": 3600}',
          200,
        ),
      );

      final credentials = await getCredentials(false);
      expect(
          credentials.accessToken.data, expectedCredentials.accessToken.data);
      // Verify other aspects of the credentials if needed
    });

    test('Obtaining credentials for impersonated service account', () async {
      final expectedCredentials = AccessCredentials(
        AccessToken(
            'token', 'scope', DateTime.now().add(Duration(hours: 1)).toUtc()),
        null,
        ['scope'],
      );

      when(mockClient.post(
        Uri.parse('https://mayjuun.com/fhir/r4'),
        headers: anyNamed('headers'),
        body: anyNamed('body'),
      )).thenAnswer(
        (_) async => http.Response(
          '{"access_token": "token", "expires_in": 3600}',
          200,
        ),
      );

      final credentials = await getCredentials(true);
      expect(
          credentials.accessToken.data, expectedCredentials.accessToken.data);
      // Verify other aspects of the credentials if needed
    });

    test('Error scenario: HTTP request fails', () async {
      when(mockClient.post(Uri.parse('https://mayjuun.com/fhir/r4'),
              headers: anyNamed('headers'), body: anyNamed('body')))
          .thenAnswer((_) async => http.Response('Error', 500));

      expect(
          () => getCredentials(false), throwsA(TypeMatcher<HttpException>()));
    });

    // Add more error scenarios or edge cases...
  });
}
