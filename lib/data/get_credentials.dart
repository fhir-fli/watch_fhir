import 'package:googleapis_auth/auth_io.dart';
import 'package:http/http.dart' as http;

import '../watch_fhir.dart';

/// Service Account Credentials
final accountCredentials = ServiceAccountCredentials.fromJson(
  providerContainer.read(assetsProvider).serviceAccountCredentials,
  impersonatedUser: null,
);

final emailAccountCredentials = ServiceAccountCredentials.fromJson(
  providerContainer.read(assetsProvider).serviceAccountCredentials,
  impersonatedUser: 'service.account@mayjuun.com',
);

/// Get credentials for service account, must pass account credentials,
/// proper scopes (which is really just google cloud) and then the http client
Future<AccessCredentials> getCredentials([bool forEmail = false]) async {
  final client = http.Client();
  try {
    AccessCredentials credentials =
        await obtainAccessCredentialsViaServiceAccount(
            forEmail ? emailAccountCredentials : accountCredentials,
            scopes,
            client);

    client.close();
    return credentials;
  } catch (e, stack) {
    print('Error: $e');
    print('Stack: $stack');
    rethrow;
  }
}
