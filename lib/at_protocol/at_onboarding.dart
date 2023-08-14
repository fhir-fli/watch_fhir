//onboarding preference builder can be used to set onboardingService parameters
import 'package:at_client/at_client.dart';
import 'package:at_onboarding_cli/at_onboarding_cli.dart';
import 'package:version/version.dart';

import 'config.dart';

/// Takes care of the onboarding for the server, accepts the arguments needed
/// from a file called config.dart which contains a map of type <String, dynamic>
/// with all of the arguments for the onboarding
Future<bool> onBoarding() async {
  AtServiceFactory? atServiceFactory;
  AtOnboardingPreference atOnboardingConfig = AtOnboardingPreference()
    ..hiveStoragePath = config['hiveStoragePath'] as String
    ..namespace = config['namespace'] as String
    ..downloadPath = config['downloadPath'] as String
    ..isLocalStoreRequired = config['isLocalStoreRequired'] as bool
    ..commitLogPath = config['commitLogPath'] as String
    ..rootDomain = config['rootDomain'] as String
    ..fetchOfflineNotifications = config['fetchOfflineNotifications'] as bool
    ..atKeysFilePath = config['atKeysFilePath'] as String
    ..useAtChops = config['useAtChops'] as bool
    ..atProtocolEmitted = config['atProtocolEmitted'] as Version;

  AtOnboardingService onboardingService = AtOnboardingServiceImpl(
    config['atSign'],
    atOnboardingConfig,
    atServiceFactory: atServiceFactory,
  );
  bool onboarded = false;
  Duration retryDuration = Duration(seconds: 3);
  while (!onboarded) {
    try {
      print('\r\x1b[KConnecting ... ');
      await Future.delayed(Duration(
          milliseconds:
              1000)); // Pause just long enough for the retry to be visible
      onboarded = await onboardingService.authenticate();
    } catch (exception) {
      print('$exception. Will retry in ${retryDuration.inSeconds} seconds');
    }
    if (!onboarded) {
      await Future.delayed(retryDuration);
    }
  }
  print('Connected');
  return true;
}
