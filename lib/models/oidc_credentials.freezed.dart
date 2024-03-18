// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'oidc_credentials.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

OidcCredentials _$OidcCredentialsFromJson(Map<String, dynamic> json) {
  return _OidcCredentials.fromJson(json);
}

/// @nodoc
mixin _$OidcCredentials {
  Uri get openIdConfiguration => throw _privateConstructorUsedError;
  String get clientId => throw _privateConstructorUsedError;
  String get clientSecret => throw _privateConstructorUsedError;
  String get proxyEndpoint => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $OidcCredentialsCopyWith<OidcCredentials> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OidcCredentialsCopyWith<$Res> {
  factory $OidcCredentialsCopyWith(
          OidcCredentials value, $Res Function(OidcCredentials) then) =
      _$OidcCredentialsCopyWithImpl<$Res, OidcCredentials>;
  @useResult
  $Res call(
      {Uri openIdConfiguration,
      String clientId,
      String clientSecret,
      String proxyEndpoint});
}

/// @nodoc
class _$OidcCredentialsCopyWithImpl<$Res, $Val extends OidcCredentials>
    implements $OidcCredentialsCopyWith<$Res> {
  _$OidcCredentialsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? openIdConfiguration = null,
    Object? clientId = null,
    Object? clientSecret = null,
    Object? proxyEndpoint = null,
  }) {
    return _then(_value.copyWith(
      openIdConfiguration: null == openIdConfiguration
          ? _value.openIdConfiguration
          : openIdConfiguration // ignore: cast_nullable_to_non_nullable
              as Uri,
      clientId: null == clientId
          ? _value.clientId
          : clientId // ignore: cast_nullable_to_non_nullable
              as String,
      clientSecret: null == clientSecret
          ? _value.clientSecret
          : clientSecret // ignore: cast_nullable_to_non_nullable
              as String,
      proxyEndpoint: null == proxyEndpoint
          ? _value.proxyEndpoint
          : proxyEndpoint // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$OidcCredentialsImplCopyWith<$Res>
    implements $OidcCredentialsCopyWith<$Res> {
  factory _$$OidcCredentialsImplCopyWith(_$OidcCredentialsImpl value,
          $Res Function(_$OidcCredentialsImpl) then) =
      __$$OidcCredentialsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {Uri openIdConfiguration,
      String clientId,
      String clientSecret,
      String proxyEndpoint});
}

/// @nodoc
class __$$OidcCredentialsImplCopyWithImpl<$Res>
    extends _$OidcCredentialsCopyWithImpl<$Res, _$OidcCredentialsImpl>
    implements _$$OidcCredentialsImplCopyWith<$Res> {
  __$$OidcCredentialsImplCopyWithImpl(
      _$OidcCredentialsImpl _value, $Res Function(_$OidcCredentialsImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? openIdConfiguration = null,
    Object? clientId = null,
    Object? clientSecret = null,
    Object? proxyEndpoint = null,
  }) {
    return _then(_$OidcCredentialsImpl(
      openIdConfiguration: null == openIdConfiguration
          ? _value.openIdConfiguration
          : openIdConfiguration // ignore: cast_nullable_to_non_nullable
              as Uri,
      clientId: null == clientId
          ? _value.clientId
          : clientId // ignore: cast_nullable_to_non_nullable
              as String,
      clientSecret: null == clientSecret
          ? _value.clientSecret
          : clientSecret // ignore: cast_nullable_to_non_nullable
              as String,
      proxyEndpoint: null == proxyEndpoint
          ? _value.proxyEndpoint
          : proxyEndpoint // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$OidcCredentialsImpl extends _OidcCredentials {
  const _$OidcCredentialsImpl(
      {required this.openIdConfiguration,
      required this.clientId,
      required this.clientSecret,
      required this.proxyEndpoint})
      : super._();

  factory _$OidcCredentialsImpl.fromJson(Map<String, dynamic> json) =>
      _$$OidcCredentialsImplFromJson(json);

  @override
  final Uri openIdConfiguration;
  @override
  final String clientId;
  @override
  final String clientSecret;
  @override
  final String proxyEndpoint;

  @override
  String toString() {
    return 'OidcCredentials(openIdConfiguration: $openIdConfiguration, clientId: $clientId, clientSecret: $clientSecret, proxyEndpoint: $proxyEndpoint)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OidcCredentialsImpl &&
            (identical(other.openIdConfiguration, openIdConfiguration) ||
                other.openIdConfiguration == openIdConfiguration) &&
            (identical(other.clientId, clientId) ||
                other.clientId == clientId) &&
            (identical(other.clientSecret, clientSecret) ||
                other.clientSecret == clientSecret) &&
            (identical(other.proxyEndpoint, proxyEndpoint) ||
                other.proxyEndpoint == proxyEndpoint));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, openIdConfiguration, clientId, clientSecret, proxyEndpoint);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$OidcCredentialsImplCopyWith<_$OidcCredentialsImpl> get copyWith =>
      __$$OidcCredentialsImplCopyWithImpl<_$OidcCredentialsImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$OidcCredentialsImplToJson(
      this,
    );
  }
}

abstract class _OidcCredentials extends OidcCredentials {
  const factory _OidcCredentials(
      {required final Uri openIdConfiguration,
      required final String clientId,
      required final String clientSecret,
      required final String proxyEndpoint}) = _$OidcCredentialsImpl;
  const _OidcCredentials._() : super._();

  factory _OidcCredentials.fromJson(Map<String, dynamic> json) =
      _$OidcCredentialsImpl.fromJson;

  @override
  Uri get openIdConfiguration;
  @override
  String get clientId;
  @override
  String get clientSecret;
  @override
  String get proxyEndpoint;
  @override
  @JsonKey(ignore: true)
  _$$OidcCredentialsImplCopyWith<_$OidcCredentialsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
