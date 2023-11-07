import 'package:shelf/shelf.dart';
import 'package:watch_fhir/watch_fhir.dart';

Future<Response> sendViaTwilio(String phoneNumber, String text) async {
  if (providerContainer.read(assetsProvider).allowTexts == false) {
    return Response.ok('Texts are not allowed');
  } else {
    if (phoneNumber.startsWith('1555') || phoneNumber.startsWith('555')) {
      return Response.ok(
          'The number "$phoneNumber" is not a legitimate number');
    } else {
      final TwilioAssets? twilioAssets =
          providerContainer.read(assetsProvider).twilioAssets;
      if (twilioAssets == null) {
        return Response.ok('Twilio assets are not configured');
      }
      {
        final TwilioFlutter twilioFlutter = TwilioFlutter(
          accountSid:
              providerContainer.read(assetsProvider).twilioAssets!.accountSid,
          authToken:
              providerContainer.read(assetsProvider).twilioAssets!.authToken,
          twilioNumber:
              providerContainer.read(assetsProvider).twilioAssets!.twilioNumber,
        );

        final dateTime = DateTime.now().toIso8601String();

        await twilioFlutter.sendSMS(toNumber: phoneNumber, messageBody: text);
        return Response.ok('Message has been sent: $dateTime');
      }
    }
  }
}
