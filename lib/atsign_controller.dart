import 'dart:developer';

import 'package:at_client/at_client.dart';
import 'package:fhir/dstu2.dart' as dstu2;
import 'package:fhir/r4.dart' as r4;
import 'package:fhir/r5.dart' as r5;
import 'package:fhir/stu3.dart' as stu3;

import 'at_protocol/at_protocol.dart';

Future atSignController() async {
  bool onboarded = false;
  while (!onboarded) {
    try {
      onboarded = await onBoarding();
    } catch (e, st) {
      log('onBoarding failed: $e\n$st');
    }
  }
  // atFhirListen(AtClientManager.getInstance().atClient, listenFunction);
}

// dynamic listenFunction(AtClient atClient, AtNotification atNotification) async {
//   try {
//     /// Make record of every notification received
//     final logged = await logNotification(
//       atClient,
//       atNotification.value,
//       atNotification.from,
//     );

//     /// If it fails, log the log, how meta! ;-P
//     if (logged is! SuccessNotError) {
//       log(logged.toString());
//     }

//     /// Note where the notification came from
//     final String fromAtSign = atNotification.from;

//     /// Check if the request is from a trusted source
//     final SuccessOrError hasRoleAccess =
//         await checkRoleAccess(atSign: fromAtSign);

//     /// If the request is not from a trusted source, return an error
//     if (hasRoleAccess is SuccessBool) {
//       if (!hasRoleAccess.value) {
//         await atClient.notificationService.notify(NotificationParams.forText(
//           'You do not have permission to access this server.',
//           fromAtSign,
//           shouldEncrypt: true,
//         ));
//       } else {
//         /// If the request is from a trusted source, parse the request
//         final AtFhirNotification atFhirNotification =
//             AtFhirNotification.fromJsonString(atNotification.key
//                 .replaceFirst('${atClient.getCurrentAtSign()}:', ''));
//         print(atFhirNotification.toJsonString());
//         await atClient.notificationService.notify(NotificationParams.forText(
//           'You do not have permission to access this server.',
//           fromAtSign,
//           shouldEncrypt: true,
//         ));

//         /// Handle the request
//         switch (atFhirNotification) {
//           case AtFhirDstu2RequestNotification():
//             {
//               final dstu2.Resource resource =
//                   await makeDstu2Request(atFhirNotification.value);
//               await atFhirNotify(
//                 atClient,
//                 AtFhirDstu2ResourceNotification(resource),
//                 fromAtSign,
//               );
//             }
//             break;
//           case AtFhirStu3RequestNotification():
//             {
//               final stu3.Resource resource =
//                   await makeStu3Request(atFhirNotification.value);
//               await atFhirNotify(
//                 atClient,
//                 AtFhirStu3ResourceNotification(resource),
//                 fromAtSign,
//               );
//             }
//             break;
//           case AtFhirR4RequestNotification():
//             {
//               final r4.Resource resource =
//                   await makeR4Request(atFhirNotification.value);
//               await atFhirNotify(
//                 atClient,
//                 AtFhirR4ResourceNotification(resource),
//                 fromAtSign,
//               );
//             }
//             break;
//           case AtFhirR5RequestNotification():
//             {
//               final r5.Resource resource =
//                   await makeR5Request(atFhirNotification.value);
//               await atFhirNotify(
//                 atClient,
//                 AtFhirR5ResourceNotification(resource),
//                 fromAtSign,
//               );
//             }
//             break;
//           default:
//             {
//               log('Unallowed notification: ${atFhirNotification.toJsonString()}');
//             }
//         }
//       }
//     }
//   } catch (e, st) {
//     log('Unable to parse request', error: e, stackTrace: st);
//   }
// }
