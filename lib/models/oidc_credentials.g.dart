// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'oidc_credentials.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$OidcCredentialsImpl _$$OidcCredentialsImplFromJson(
        Map<String, dynamic> json) =>
    _$OidcCredentialsImpl(
      openIdConfiguration: Uri.parse(json['openIdConfiguration'] as String),
      clientId: json['clientId'] as String,
      clientSecret: json['clientSecret'] as String,
      proxyEndpoint: json['proxyEndpoint'] as String,
    );

Map<String, dynamic> _$$OidcCredentialsImplToJson(
        _$OidcCredentialsImpl instance) =>
    <String, dynamic>{
      'openIdConfiguration': instance.openIdConfiguration.toString(),
      'clientId': instance.clientId,
      'clientSecret': instance.clientSecret,
      'proxyEndpoint': instance.proxyEndpoint,
    };
