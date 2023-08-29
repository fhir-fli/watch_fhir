import 'dart:convert';

import 'package:googleapis/gmail/v1.dart' as gmail;
import "package:googleapis_auth/auth_io.dart";
import 'package:shelf/shelf.dart';

import '../watch_fhir.dart';

/// Function for sending a message via email
Future<Response> sendViaEmail(String email, String text) async {
  /// The assets.yaml file allows specification about whether emails for
  /// communication should be allowed. Since emails are basically free, the
  /// default for this is true.
  if (providerContainer.read(assetsProvider).allowEmails) {
    String getBase64Email(String source) =>
        base64UrlEncode(utf8.encode(source));

    final clientCredentials = emailAccountCredentials;

    final authClient = await clientViaServiceAccount(
        clientCredentials, ['https://www.googleapis.com/auth/gmail.send']);

    final gmailApi = gmail.GmailApi(authClient);

    String from = 'service.account@mayjuun.com';
    String to = email;
    String subject = 'Message from MayJuun';
    String contentType = 'text/html';
    String charset = 'utf-8';
    String contentTransferEncoding = 'base64';
    String emailContent = text;

    try {
      await gmailApi.users.messages.send(
          gmail.Message.fromJson({
            'raw': getBase64Email('From: $from\r\n'
                'To: $to\r\n'
                'Subject: $subject\r\n'
                'Content-Type: $contentType; charset=$charset\r\n'
                'Content-Transfer-Encoding: $contentTransferEncoding\r\n\r\n'
                '$emailContent'),
          }),
          from);

      return Response.ok('Email has been sent: ${DateTime.now()}');
    } catch (e, s) {
      /// At some point this should be something other than ok response, the
      /// problem is that for many services, if they don't receive an ok
      /// response, they will continuously retry the request
      return Response.ok('There was an error, $e.'
          'The stack at the time of the error was: $s');
    }
  }
  return Response.ok('There has been some kind of mistake sending email.');
}
