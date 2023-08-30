import 'package:test/test.dart';
import 'package:watch_fhir/watch_fhir.dart';

void main() {
  group('WatchFhirAssets', () {
    test('Initialization with default values', () {
      final assets = WatchFhirAssets();

      expect(assets.communicationsOnly, false);
      expect(assets.allowEmails, true);
      expect(assets.allowTexts, false);
      expect(assets.serviceAccountEmail, isNull);
      expect(assets.emailSubject, isNull);
      expect(assets.organizationId, isNull);
      expect(assets.cuestionarioUrl, isNull);
      expect(assets.fhirUrl, '');
      expect(assets.twilioAssets, isNull);
      expect(assets.serviceAccountCredentials, isNull);
    });

    test('Deserialization from JSON', () {
      final json = {
        'communicationsOnly': true,
        'allowEmails': false,
        'allowTexts': true,
        'serviceAccountEmail': 'test@example.com',
        'emailSubject': 'Test Subject',
        'organizationId': 'org123',
        'cuestionarioUrl': 'https://example.com/questionnaire',
        'fhirUrl': 'https://example.com/fhir',
        'twilioAssets': {
          'accountSid': 'sid123',
          'authToken': 'auth123',
          'twilioNumber': '+1234567890',
          'minute': '15',
          'hour': '3',
          'day': '5',
          'month': '8',
          'dayOfWeek': '2',
        },
      };

      final assets = WatchFhirAssets.fromJson(json);

      expect(assets.communicationsOnly, true);
      expect(assets.allowEmails, false);
      expect(assets.allowTexts, true);
      expect(assets.serviceAccountEmail, 'test@example.com');
      expect(assets.emailSubject, 'Test Subject');
      expect(assets.organizationId, 'org123');
      expect(assets.cuestionarioUrl, 'https://example.com/questionnaire');
      expect(assets.fhirUrl, 'https://example.com/fhir');
      expect(assets.twilioAssets, isA<TwilioAssets>());
      expect(assets.serviceAccountCredentials, null);
    });
  });

  group('TwilioAssets', () {
    test('Deserialization from JSON', () {
      final json = {
        'accountSid': 'sid123',
        'authToken': 'auth123',
        'twilioNumber': '+1234567890',
        'minute': '15',
        'hour': '3',
        'day': '5',
        'month': '8',
        'dayOfWeek': '2',
      };

      final twilioAssets = TwilioAssets.fromJson(json);

      expect(twilioAssets.accountSid, 'sid123');
      expect(twilioAssets.authToken, 'auth123');
      expect(twilioAssets.twilioNumber, '+1234567890');
      expect(twilioAssets.minute, '15');
      expect(twilioAssets.hour, '3');
      expect(twilioAssets.day, '5');
      expect(twilioAssets.month, '8');
      expect(twilioAssets.dayOfWeek, '2');
    });
  });
}
