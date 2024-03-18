// ignore_for_file: invalid_annotation_target, sort_unnamed_constructors_first, sort_constructors_first, prefer_mixin

// Package imports:
import 'dart:convert';
import 'dart:io';

import 'package:googleapis_auth/auth_io.dart';
import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:watch_fhir/watch_fhir.dart';
import 'package:yaml/yaml.dart';

part 'watch_fhir_assets.g.dart';

final ProviderContainer providerContainer = ProviderContainer();

@Riverpod(keepAlive: true)
class Assets extends _$Assets {
  @override
  WatchFhirAssets build() => WatchFhirAssets();

  Future<void> init() async {
    final String assetsYaml = File('assets/assets.yaml').readAsStringSync();
    final YamlMap yaml = loadYaml(assetsYaml);
    final Map<String, dynamic> json = jsonDecode(jsonEncode(yaml));
    state = WatchFhirAssets.fromJson(json);
  }
}

class WatchFhirAssets {
  WatchFhirAssets({
    this.atSign = false,
    this.listener = true,
    this.resourceTypes = const <String>[],
    this.proxy,
    this.oidcCredentials,
    this.communicationsOnly = false,
    this.allowEmails = true,
    this.allowTexts = false,
    this.serviceAccountEmail,
    this.emailSubject,
    this.organizationId,
    this.cuestionarioUrl,
    this.twilioAssets,
    this.serviceAccountCredentials,
  });

  WatchFhirAssets.fromJson(
    Map<String, dynamic> json,
  )   : atSign = json['atSign'] ?? false,
        listener = json['listener'] ?? true,
        resourceTypes = json['resourceTypes'] is! List
            ? <String>[]
            : List<String>.from(json['resourceTypes']),
        proxy = json['proxy'] ?? false,
        oidcCredentials = json['oidcCredentials'] is! Map
            ? null
            : <String, OidcCredentials>{
                for (final entry in json['oidcCredentials'].entries)
                  entry.key: OidcCredentials.fromJson(entry.value),
              },
        communicationsOnly = json['communicationsOnly'] ?? false,
        allowEmails = json['allowEmails'] ?? true,
        allowTexts = json['allowTexts'] ?? false,
        serviceAccountEmail = json['serviceAccountEmail']?.toString(),
        emailSubject = json['emailSubject']?.toString(),
        organizationId = json['organizationId']?.toString(),
        cuestionarioUrl = json['cuestionarioUrl']?.toString(),
        twilioAssets = json['twilioAssets'] == null
            ? null
            : TwilioAssets.fromJson(
                json['twilioAssets'],
              ),
        serviceAccountCredentials = json['serviceAccountCredentials'] is! Map
            ? null
            : ServiceAccountCredentials.fromJson(
                json['serviceAccountCredentials'],
              );

  bool atSign;
  bool listener;
  List<String> resourceTypes;
  bool? proxy;
  Map<String, OidcCredentials>? oidcCredentials;
  bool communicationsOnly;
  bool allowEmails;
  bool allowTexts;
  String? serviceAccountEmail;
  String? emailSubject;
  String? organizationId;
  String? cuestionarioUrl;
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
