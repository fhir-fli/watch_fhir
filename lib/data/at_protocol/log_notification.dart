import 'package:at_client/at_client.dart';

import '../../watch_fhir.dart';

Future<SuccessOrError> logNotification(
  AtClient atClient,
  String? notification,
  String atSign, [
  String? nameSpace = 'fhir',
]) async {
  final now = DateTime.now()
      .toIso8601String()
      .replaceAll('T', '')
      .replaceAll(' ', '')
      .replaceAll(':', '')
      .replaceAll('-', '')
      .substring(0, 16);

  return FhirliteSuccess.success();

  // return await atSignPut(
  //   atClient: atClient,
  //   atKey: 'fhir.request.$now',
  //   value: notification ?? '',
  //   sharedWith: atSign,
  //   nameSpace: nameSpace,
  // );
}
