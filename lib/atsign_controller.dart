import 'dart:developer';

import 'package:at_client/at_client.dart';
import 'package:fhir/dstu2.dart' as dstu2;
import 'package:fhir/r4.dart' as r4;
import 'package:fhir/r5.dart' as r5;
import 'package:fhir/stu3.dart' as stu3;

import 'watch_fhir.dart';

Future atSignController() async {
  bool onboarded = false;
  while (!onboarded) {
    try {
      onboarded = await onBoarding();
    } catch (e, st) {
      log('onBoarding failed: $e\n$st');
    }
  }
  atFhirListen(AtClientManager.getInstance().atClient, listenFunction);
}

dynamic listenFunction(AtClient atClient, AtNotification atNotification) async {
  try {
    /// Make record of every notification received
    final logged = await logNotification(
      atClient,
      atNotification.value,
      atNotification.from,
    );

    /// If it fails, log the log, how meta! ;-P
    if (logged is! FhirliteSuccess) {
      log(logged.toString());
    }

    /// Note where the notification came from
    final String fromAtSign = atNotification.from;

    if (atNotification.value == null) {
      throw Exception('Notification value is null');
    } else {
      /// If the request is from a trusted source, parse the request
      final AtFhirNotification atFhirNotification =
          AtFhirNotification.fromJsonString(atNotification.value!);
      await atClient.notificationService.notify(NotificationParams.forText(
        'You do not have permission to access this server.',
        fromAtSign,
        shouldEncrypt: true,
      ));

      print(atFhirNotification.runtimeType);

      /// Handle the request
      switch (atFhirNotification) {
        case AtFhirDstu2RequestNotification():
          {
            final dstu2.Resource resource =
                await forwardDstu2Request(atFhirNotification.value);
            await atFhirNotify(
              atClient,
              AtFhirDstu2ResourceNotification(resource),
              fromAtSign,
            );
          }
          break;
        case AtFhirStu3RequestNotification():
          {
            final stu3.Resource resource =
                await forwardStu3Request(atFhirNotification.value);
            await atFhirNotify(
              atClient,
              AtFhirStu3ResourceNotification(resource),
              fromAtSign,
            );
          }
          break;
        case AtFhirR4RequestNotification():
          {
            final r4.Resource resource =
                await forwardR4Request(atFhirNotification.value);

            print(resource.toJson());
            await atFhirNotify(
              atClient,
              AtFhirR4ResourceNotification(resource),
              fromAtSign,
            );
          }
          break;
        case AtFhirR5RequestNotification():
          {
            final r5.Resource resource =
                await forwardR5Request(atFhirNotification.value);
            await atFhirNotify(
              atClient,
              AtFhirR5ResourceNotification(resource),
              fromAtSign,
            );
          }
          break;
        default:
          {
            log('Unallowed notification: ${atFhirNotification.toJsonString()}');
          }
      }
    }
  } catch (e, st) {
    log('Unable to parse request', error: e, stackTrace: st);
  }
}
