// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'fcm_token_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

FcmTokenDto _$FcmTokenDtoFromJson(Map<String, dynamic> json) {
  return _FcmTokenDto.fromJson(json);
}

/// @nodoc
mixin _$FcmTokenDto {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'user_id')
  String get userId => throw _privateConstructorUsedError;
  String get token => throw _privateConstructorUsedError;
  String get platform => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime? get createdAt => throw _privateConstructorUsedError;

  /// Serializes this FcmTokenDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of FcmTokenDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FcmTokenDtoCopyWith<FcmTokenDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FcmTokenDtoCopyWith<$Res> {
  factory $FcmTokenDtoCopyWith(
    FcmTokenDto value,
    $Res Function(FcmTokenDto) then,
  ) = _$FcmTokenDtoCopyWithImpl<$Res, FcmTokenDto>;
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'user_id') String userId,
    String token,
    String platform,
    @JsonKey(name: 'created_at') DateTime? createdAt,
  });
}

/// @nodoc
class _$FcmTokenDtoCopyWithImpl<$Res, $Val extends FcmTokenDto>
    implements $FcmTokenDtoCopyWith<$Res> {
  _$FcmTokenDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FcmTokenDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? token = null,
    Object? platform = null,
    Object? createdAt = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            userId: null == userId
                ? _value.userId
                : userId // ignore: cast_nullable_to_non_nullable
                      as String,
            token: null == token
                ? _value.token
                : token // ignore: cast_nullable_to_non_nullable
                      as String,
            platform: null == platform
                ? _value.platform
                : platform // ignore: cast_nullable_to_non_nullable
                      as String,
            createdAt: freezed == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$FcmTokenDtoImplCopyWith<$Res>
    implements $FcmTokenDtoCopyWith<$Res> {
  factory _$$FcmTokenDtoImplCopyWith(
    _$FcmTokenDtoImpl value,
    $Res Function(_$FcmTokenDtoImpl) then,
  ) = __$$FcmTokenDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'user_id') String userId,
    String token,
    String platform,
    @JsonKey(name: 'created_at') DateTime? createdAt,
  });
}

/// @nodoc
class __$$FcmTokenDtoImplCopyWithImpl<$Res>
    extends _$FcmTokenDtoCopyWithImpl<$Res, _$FcmTokenDtoImpl>
    implements _$$FcmTokenDtoImplCopyWith<$Res> {
  __$$FcmTokenDtoImplCopyWithImpl(
    _$FcmTokenDtoImpl _value,
    $Res Function(_$FcmTokenDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of FcmTokenDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? token = null,
    Object? platform = null,
    Object? createdAt = freezed,
  }) {
    return _then(
      _$FcmTokenDtoImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        userId: null == userId
            ? _value.userId
            : userId // ignore: cast_nullable_to_non_nullable
                  as String,
        token: null == token
            ? _value.token
            : token // ignore: cast_nullable_to_non_nullable
                  as String,
        platform: null == platform
            ? _value.platform
            : platform // ignore: cast_nullable_to_non_nullable
                  as String,
        createdAt: freezed == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$FcmTokenDtoImpl implements _FcmTokenDto {
  const _$FcmTokenDtoImpl({
    required this.id,
    @JsonKey(name: 'user_id') required this.userId,
    required this.token,
    required this.platform,
    @JsonKey(name: 'created_at') this.createdAt,
  });

  factory _$FcmTokenDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$FcmTokenDtoImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'user_id')
  final String userId;
  @override
  final String token;
  @override
  final String platform;
  @override
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;

  @override
  String toString() {
    return 'FcmTokenDto(id: $id, userId: $userId, token: $token, platform: $platform, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FcmTokenDtoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.token, token) || other.token == token) &&
            (identical(other.platform, platform) ||
                other.platform == platform) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, userId, token, platform, createdAt);

  /// Create a copy of FcmTokenDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FcmTokenDtoImplCopyWith<_$FcmTokenDtoImpl> get copyWith =>
      __$$FcmTokenDtoImplCopyWithImpl<_$FcmTokenDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FcmTokenDtoImplToJson(this);
  }
}

abstract class _FcmTokenDto implements FcmTokenDto {
  const factory _FcmTokenDto({
    required final String id,
    @JsonKey(name: 'user_id') required final String userId,
    required final String token,
    required final String platform,
    @JsonKey(name: 'created_at') final DateTime? createdAt,
  }) = _$FcmTokenDtoImpl;

  factory _FcmTokenDto.fromJson(Map<String, dynamic> json) =
      _$FcmTokenDtoImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'user_id')
  String get userId;
  @override
  String get token;
  @override
  String get platform;
  @override
  @JsonKey(name: 'created_at')
  DateTime? get createdAt;

  /// Create a copy of FcmTokenDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FcmTokenDtoImplCopyWith<_$FcmTokenDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
