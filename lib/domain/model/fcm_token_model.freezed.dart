// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'fcm_token_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$FcmTokenModel {
  String get id => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  String get token => throw _privateConstructorUsedError;
  String get platform => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;

  /// Create a copy of FcmTokenModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FcmTokenModelCopyWith<FcmTokenModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FcmTokenModelCopyWith<$Res> {
  factory $FcmTokenModelCopyWith(
    FcmTokenModel value,
    $Res Function(FcmTokenModel) then,
  ) = _$FcmTokenModelCopyWithImpl<$Res, FcmTokenModel>;
  @useResult
  $Res call({
    String id,
    String userId,
    String token,
    String platform,
    DateTime? createdAt,
  });
}

/// @nodoc
class _$FcmTokenModelCopyWithImpl<$Res, $Val extends FcmTokenModel>
    implements $FcmTokenModelCopyWith<$Res> {
  _$FcmTokenModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FcmTokenModel
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
abstract class _$$FcmTokenModelImplCopyWith<$Res>
    implements $FcmTokenModelCopyWith<$Res> {
  factory _$$FcmTokenModelImplCopyWith(
    _$FcmTokenModelImpl value,
    $Res Function(_$FcmTokenModelImpl) then,
  ) = __$$FcmTokenModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String userId,
    String token,
    String platform,
    DateTime? createdAt,
  });
}

/// @nodoc
class __$$FcmTokenModelImplCopyWithImpl<$Res>
    extends _$FcmTokenModelCopyWithImpl<$Res, _$FcmTokenModelImpl>
    implements _$$FcmTokenModelImplCopyWith<$Res> {
  __$$FcmTokenModelImplCopyWithImpl(
    _$FcmTokenModelImpl _value,
    $Res Function(_$FcmTokenModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of FcmTokenModel
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
      _$FcmTokenModelImpl(
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

class _$FcmTokenModelImpl implements _FcmTokenModel {
  const _$FcmTokenModelImpl({
    required this.id,
    required this.userId,
    required this.token,
    required this.platform,
    this.createdAt,
  });

  @override
  final String id;
  @override
  final String userId;
  @override
  final String token;
  @override
  final String platform;
  @override
  final DateTime? createdAt;

  @override
  String toString() {
    return 'FcmTokenModel(id: $id, userId: $userId, token: $token, platform: $platform, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FcmTokenModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.token, token) || other.token == token) &&
            (identical(other.platform, platform) ||
                other.platform == platform) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, id, userId, token, platform, createdAt);

  /// Create a copy of FcmTokenModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FcmTokenModelImplCopyWith<_$FcmTokenModelImpl> get copyWith =>
      __$$FcmTokenModelImplCopyWithImpl<_$FcmTokenModelImpl>(this, _$identity);
}

abstract class _FcmTokenModel implements FcmTokenModel {
  const factory _FcmTokenModel({
    required final String id,
    required final String userId,
    required final String token,
    required final String platform,
    final DateTime? createdAt,
  }) = _$FcmTokenModelImpl;

  @override
  String get id;
  @override
  String get userId;
  @override
  String get token;
  @override
  String get platform;
  @override
  DateTime? get createdAt;

  /// Create a copy of FcmTokenModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FcmTokenModelImplCopyWith<_$FcmTokenModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
