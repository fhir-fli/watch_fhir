// ignore_for_file: invalid_annotation_target, sort_unnamed_constructors_first, sort_constructors_first, prefer_mixin

// Package imports:
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:oauth2/oauth2.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:watch_fhir/watch_fhir.dart';

part 'oidc_client.g.dart';

@Riverpod(keepAlive: true)
class ClientOidc extends _$ClientOidc {
  @override
  OidcClient build() => OidcClient();

  Future<void> init(String path) async {
    final credentials = ref.read(assetsProvider).oidcCredentials?[path];
    if (credentials?.openIdConfiguration == null) {
      throw Exception('No openIdConfiguration found for $path');
    }
    final endpointsResponse = await http.get(credentials!.openIdConfiguration);
    final endpoints = jsonDecode(endpointsResponse.body);
    final token = endpoints['token_endpoint'];
    final Map<String, String> headers = {
      'Content-Type': 'application/x-www-form-urlencoded'
    };
    final bodyCredentials = {
      'client_id': credentials.clientId,
      'client_secret': credentials.clientSecret,
      'grant_type': 'client_credentials',
    };

    final accessResponse = await http.post(Uri.parse(token),
        headers: headers, body: bodyCredentials);
    final body = jsonDecode(accessResponse.body);

    state = OidcClient(
      path: path,
      wellKnown: credentials.openIdConfiguration,
      tokenEndpoint: token,
      tokenType: body['token_type'],
      clientId: credentials.clientId,
      clientSecret: credentials.clientSecret,
      accessToken: body['access_token'],
      refreshToken: body['refresh_token'],
      expiresIn: DateTime.now().add(Duration(seconds: body['expires_in'])),
      refreshExpiresIn:
          DateTime.now().add(Duration(seconds: body['refresh_expires_in'])),
      scopes: body['scope'].toString().split(' '),
    );
  }

  Future<Client> clientForRequest() async {
    if (state.accessToken == null) {
      await init(state.path!);
    }
    final client = Client(
      Credentials(
        state.accessToken!,
        refreshToken: state.refreshToken,
        tokenEndpoint: Uri.parse(state.tokenEndpoint!),
        expiration: state.expiresIn!,
        scopes: state.scopes,
      ),
      identifier: state.clientId,
      secret: state.clientSecret,
    );
    if (DateTime.now().isBefore(state.expiresIn!)) {
      return client;
    } else if (DateTime.now().isBefore(state.refreshExpiresIn!)) {
      final refresh = await client.refreshCredentials();
      state = state.copyWith(
        accessToken: refresh.credentials.accessToken,
        refreshToken: refresh.credentials.refreshToken,
        expiresIn: refresh.credentials.expiration,
      );
      return client;
    } else if (state.path != null) {
      await init(state.path!);
      return Client(
        Credentials(
          state.accessToken!,
          refreshToken: state.refreshToken,
          tokenEndpoint: Uri.parse(state.tokenEndpoint!),
          expiration: state.expiresIn!,
          scopes: state.scopes,
        ),
        identifier: state.clientId,
        secret: state.clientSecret,
      );
    } else {
      throw 'Cannot create new client';
    }
  }
}

class OidcClient {
  final String? path;
  final Uri? wellKnown;
  final String? tokenEndpoint;
  final String? tokenType;
  String? clientId;
  String? clientSecret;
  final String? accessToken;
  final String? refreshToken;
  final DateTime? expiresIn;
  final DateTime? refreshExpiresIn;
  final List<String>? scopes;

  OidcClient({
    this.path,
    this.wellKnown,
    this.tokenEndpoint,
    this.tokenType,
    this.clientId,
    this.clientSecret,
    this.accessToken,
    this.refreshToken,
    this.expiresIn,
    this.refreshExpiresIn,
    this.scopes,
  });

  OidcClient copyWith({
    Uri? wellKnown,
    String? tokenEndpoint,
    String? tokenType,
    String? clientId,
    String? clientSecret,
    String? accessToken,
    String? refreshToken,
    DateTime? expiresIn,
    DateTime? refreshExpiresIn,
    List<String>? scopes,
  }) {
    return OidcClient(
      wellKnown: wellKnown ?? this.wellKnown,
      tokenEndpoint: tokenEndpoint ?? this.tokenEndpoint,
      tokenType: tokenType ?? this.tokenType,
      clientId: clientId ?? this.clientId,
      clientSecret: clientSecret ?? this.clientSecret,
      accessToken: accessToken ?? this.accessToken,
      refreshToken: refreshToken ?? this.refreshToken,
      expiresIn: expiresIn ?? this.expiresIn,
      refreshExpiresIn: refreshExpiresIn ?? this.refreshExpiresIn,
      scopes: scopes ?? this.scopes,
    );
  }
}
