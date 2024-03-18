import 'package:freezed_annotation/freezed_annotation.dart';

part 'oidc_credentials.freezed.dart';
part 'oidc_credentials.g.dart';

@freezed
class OidcCredentials with _$OidcCredentials {
  const OidcCredentials._();

  const factory OidcCredentials({
    required Uri openIdConfiguration,
    required String clientId,
    required String clientSecret,
    required String proxyEndpoint,
  }) = _OidcCredentials;

  factory OidcCredentials.fromJson(Map<String, dynamic> json) =>
      _$OidcCredentialsFromJson(json);
}
