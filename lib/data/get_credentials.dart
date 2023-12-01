import 'package:googleapis_auth/auth_io.dart';
import 'package:http/http.dart' as http;

import '../watch_fhir.dart';

/// Get credentials for service account, must pass account credentials,
/// proper scopes (which is really just google cloud) and then the http client
Future<AccessCredentials> getCredentials([bool forEmail = false]) async {
  final client = http.Client();
  try {
    final ServiceAccountCredentials? credentials =
        serviceAccountCredentials(forEmail);
    if (credentials == null) {
      throw ArgumentError('No service account credentials');
    }
    AccessCredentials accessCredentials =
        await obtainAccessCredentialsViaServiceAccount(
            serviceAccountCredentials(forEmail)!, scopes, client);

    client.close();
    return accessCredentials;
  } catch (e, stack) {
    print('Error: $e');
    print('Stack: $stack');
    rethrow;
  }
}

ServiceAccountCredentials? serviceAccountCredentials(bool forEmail) {
  final ServiceAccountCredentials? credentials =
      providerContainer.read(assetsProvider).serviceAccountCredentials;
  if (credentials == null) {
    return null;
  } else if (!forEmail) {
    return credentials;
  } else {
    return ServiceAccountCredentials(
        credentials.email, credentials.clientId, credentials.privateKey,
        impersonatedUser: 'service.account@mayjuun.com');
  }
}
