// ignore_for_file: invalid_annotation_target, sort_unnamed_constructors_first, sort_constructors_first, prefer_mixin

// Dart imports:

// Package imports:
import 'package:googleapis_auth/auth_io.dart';

class WatchFhirAssets {
  WatchFhirAssets({
    this.allowEmails = true,
    this.allowTexts = false,
    this.serviceAccountEmail,
    this.emailSubject,
    this.twilioAssets,
    this.serviceAccountCredentials,
  });

  WatchFhirAssets.fromJson(
    Map<String, dynamic> json,
  )   : allowEmails = json['allowEmails'],
        allowTexts = json['allowTexts'],
        serviceAccountEmail = json['serviceAccountEmail'],
        emailSubject = json['emailSubject'],
        twilioAssets = TwilioAssets.fromJson(
          json['twilioAssets'],
        ),
        serviceAccountCredentials = ServiceAccountCredentials.fromJson(
          json['serviceAccountCredentials'],
        );

  bool allowEmails;
  bool allowTexts;
  String? serviceAccountEmail;
  String? emailSubject;
  TwilioAssets? twilioAssets;
  ServiceAccountCredentials? serviceAccountCredentials;
}

class TwilioAssets {
  TwilioAssets({
    required this.accountSid,
    required this.authToken,
    required this.twilioNumber,
    this.minute = '0',
    this.hour = '*',
    this.day = '*',
    this.month = '*',
    this.dayOfWeek = '*',
  });

  factory TwilioAssets.fromJson(Map<String, dynamic> json) => TwilioAssets(
        accountSid: json['accountSid'] ?? '',
        authToken: json['authToken'] ?? '',
        twilioNumber: json['twilioNumber'] ?? '',
        minute: json['minute'],
        hour: json['hour'],
        day: json['day'],
        month: json['month'],
        dayOfWeek: json['dayOfWeek'],
      );

  String accountSid;

  /// AuthToken from your Twilio Account
  String authToken;

  /// Twilio Phone Number
  String twilioNumber;

  /// The following values can be integers or "*"
  /// It uses this package: https://pub.dev/packages/cron
  /// Here is a nice tutorial: https://medium.com/flutterworld/flutter-run-function-repeatedly-using-cron-4aa030eda332
  /// The 5 together make up a cron string "0 * * * * *" this default value runs every hour
  String minute = '0';
  String hour = '*';
  String day = '*';
  String month = '*';
  String dayOfWeek = '*';
}
