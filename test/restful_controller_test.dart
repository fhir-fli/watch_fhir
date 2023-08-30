import 'dart:convert';
import 'package:shelf/shelf.dart';
import 'package:test/test.dart';
import 'package:watch_fhir/restful_controller.dart';

void main() {
  group('RestfulController', () {
    late RestfulController controller;

    setUp(() {
      controller = RestfulController();
    });

    test('Generic FHIR route should return method and endpoint', () async {
      print(Uri.base);
      final router = controller.handler;
      final request = Request('GET', Uri.parse('/fhir/dstu2'));
      final response = await router(request);
      expect(response.statusCode, equals(200));
      expect(await response.readAsString(),
          contains('GET made to the generic endpoint'));
    });

    test('Extended FHIR route should return method and endpoint', () async {
      final router = controller.handler;
      final request = Request('GET', Uri.parse('https://mayjuun.com/fhir/stu3/Patient/123'));
      final response = await router(request);
      expect(response.statusCode, equals(200));
      expect(await response.readAsString(),
          contains('GET made to the extended endpoint'));
    });

    test('FHIRPath route should return method and endpoint', () async {
      final router = controller.handler;
      final request = Request('GET', Uri.parse(r'https://mayjuun.com/fhir/r4/$fhirpath'));
      final response = await router(request);
      expect(response.statusCode, equals(200));
      expect(await response.readAsString(),
          contains('GET made to the fhirpath endpoint'));
    });

    test('GCP Pub/Sub route should return method and endpoint', () async {
      final router = controller.handler;

      final payload = {
        'message': {'data': base64.encode(utf8.encode('test'))}
      };
      final requestBody = jsonEncode(payload);
      final request = Request('POST', Uri.parse('https://mayjuun.com/fhir/gcp/r5'))
        ..headers['content-type'] = 'application/json'
        ..headers['x-goog-pubsub-subscription'] = 'test-subscription';

      // Creating a new Request object with the body
      final requestWithBody = Request(request.method, request.url,
          body: requestBody, headers: request.headers);

      final response = await router(requestWithBody);
      expect(response.statusCode, equals(200));
      expect(await response.readAsString(),
          contains('POST made to the GCP endpoint'));
    });

    test('Non-matching route should return not found', () async {
      final router = controller.handler;
      final request = Request('GET', Uri.parse('https://mayjuun.com/nonexistent'));
      final response = await router(request);
      expect(response.statusCode, equals(200)); // Should be 404 in production
      expect(await response.readAsString(), contains('Page not found'));
    });

    test('Empty payload should return empty list', () {
      final result = pathFromPayload('', 'dstu2');
      expect(result, isEmpty);
    });

    test('Invalid payload should return empty list', () {
      final result = pathFromPayload('{"message": {}}', 'r4');
      expect(result, isEmpty);
    });

    test('Valid payload should return ResourceType and ID', () {
      final payload = {
        'message': {'data': base64.encode(utf8.encode('Patient/123'))}
      };
      final result = pathFromPayload(jsonEncode(payload), 'stu3');
      expect(result, equals(['Patient', '123']));
    });
  });
}
