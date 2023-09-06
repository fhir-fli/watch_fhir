// ignore_for_file: invalid_annotation_target, sort_unnamed_constructors_first, sort_constructors_first, prefer_mixin

// Package imports:
import 'dart:convert';

import 'package:googleapis_auth/auth_io.dart';
import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:yaml/yaml.dart';

import '../watch_fhir.dart';

part 'watch_fhir_assets.g.dart';

final ProviderContainer providerContainer = ProviderContainer();

@riverpod
class Assets extends _$Assets {
  @override
  WatchFhirAssets build() => WatchFhirAssets();

  Future<void> init() async {
    final YamlMap yaml = loadYaml(assetsYaml);
    final Map<String, dynamic> json = jsonDecode(jsonEncode(yaml));
    state = WatchFhirAssets.fromJson(json);
  }
}

class WatchFhirAssets {
  WatchFhirAssets({
    this.communicationsOnly = false,
    this.allowEmails = true,
    this.allowTexts = false,
    this.serviceAccountEmail,
    this.emailSubject,
    this.organizationId,
    this.cuestionarioUrl,
    this.fhirUrl = '',
    this.twilioAssets,
    this.serviceAccountCredentials,
  });

  WatchFhirAssets.fromJson(
    Map<String, dynamic> json,
  )   : communicationsOnly = json['communicationsOnly'],
        allowEmails = json['allowEmails'],
        allowTexts = json['allowTexts'],
        serviceAccountEmail = json['serviceAccountEmail']?.toString(),
        emailSubject = json['emailSubject']?.toString(),
        organizationId = json['organizationId']?.toString(),
        cuestionarioUrl = json['cuestionarioUrl']?.toString(),
        fhirUrl = json['fhirUrl'].toString(),
        twilioAssets = TwilioAssets.fromJson(
          json['twilioAssets'],
        ),
        serviceAccountCredentials = json['serviceAccountCredentials'] is! Map
            ? null
            : ServiceAccountCredentials.fromJson(
                json['serviceAccountCredentials'],
              );

  bool communicationsOnly;
  bool allowEmails;
  bool allowTexts;
  String? serviceAccountEmail;
  String? emailSubject;
  String? organizationId;
  String? cuestionarioUrl;
  String fhirUrl;
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
