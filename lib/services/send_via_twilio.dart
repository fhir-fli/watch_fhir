import 'package:shelf/shelf.dart';
import 'package:watch_fhir/watch_fhir.dart';

Future<Response> sendViaTwilio(String phoneNumber, String text) async {
  if (phoneNumber.startsWith('1555') || phoneNumber.startsWith('555')) {
    return Response.ok('The number "$phoneNumber" is not a legitimate number');
  } else {
    final TwilioAssets? twilioAssets = watchFhirAssets.twilioAssets;
    if (twilioAssets == null) {
      return Response.ok('Twilio assets are not configured');
    }
    {
      final TwilioFlutter twilioFlutter = TwilioFlutter(
        accountSid: watchFhirAssets.twilioAssets!.accountSid,
        authToken: watchFhirAssets.twilioAssets!.authToken,
        twilioNumber: watchFhirAssets.twilioAssets!.twilioNumber,
      );

      final dateTime = DateTime.now().toIso8601String();

      await twilioFlutter.sendSMS(toNumber: phoneNumber, messageBody: text);
      return Response.ok('Message has been sent: $dateTime');
    }
  }
}
