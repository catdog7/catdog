// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'friend_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

FriendDto _$FriendDtoFromJson(Map<String, dynamic> json) {
  return _FriendDto.fromJson(json);
}

/// @nodoc
mixin _$FriendDto {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'user_a_id')
  String get userAId => throw _privateConstructorUsedError;
  @JsonKey(name: 'user_b_id')
  String get userBId => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime? get createdAt => throw _privateConstructorUsedError;

  /// Serializes this FriendDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of FriendDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FriendDtoCopyWith<FriendDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FriendDtoCopyWith<$Res> {
  factory $FriendDtoCopyWith(FriendDto value, $Res Function(FriendDto) then) =
      _$FriendDtoCopyWithImpl<$Res, FriendDto>;
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'user_a_id') String userAId,
    @JsonKey(name: 'user_b_id') String userBId,
    @JsonKey(name: 'created_at') DateTime? createdAt,
  });
}

/// @nodoc
class _$FriendDtoCopyWithImpl<$Res, $Val extends FriendDto>
    implements $FriendDtoCopyWith<$Res> {
  _$FriendDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FriendDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userAId = null,
    Object? userBId = null,
    Object? createdAt = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            userAId: null == userAId
                ? _value.userAId
                : userAId // ignore: cast_nullable_to_non_nullable
                      as String,
            userBId: null == userBId
                ? _value.userBId
                : userBId // ignore: cast_nullable_to_non_nullable
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
abstract class _$$FriendDtoImplCopyWith<$Res>
    implements $FriendDtoCopyWith<$Res> {
  factory _$$FriendDtoImplCopyWith(
    _$FriendDtoImpl value,
    $Res Function(_$FriendDtoImpl) then,
  ) = __$$FriendDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'user_a_id') String userAId,
    @JsonKey(name: 'user_b_id') String userBId,
    @JsonKey(name: 'created_at') DateTime? createdAt,
  });
}

/// @nodoc
class __$$FriendDtoImplCopyWithImpl<$Res>
    extends _$FriendDtoCopyWithImpl<$Res, _$FriendDtoImpl>
    implements _$$FriendDtoImplCopyWith<$Res> {
  __$$FriendDtoImplCopyWithImpl(
    _$FriendDtoImpl _value,
    $Res Function(_$FriendDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of FriendDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userAId = null,
    Object? userBId = null,
    Object? createdAt = freezed,
  }) {
    return _then(
      _$FriendDtoImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        userAId: null == userAId
            ? _value.userAId
            : userAId // ignore: cast_nullable_to_non_nullable
                  as String,
        userBId: null == userBId
            ? _value.userBId
            : userBId // ignore: cast_nullable_to_non_nullable
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
class _$FriendDtoImpl implements _FriendDto {
  const _$FriendDtoImpl({
    required this.id,
    @JsonKey(name: 'user_a_id') required this.userAId,
    @JsonKey(name: 'user_b_id') required this.userBId,
    @JsonKey(name: 'created_at') this.createdAt,
  });

  factory _$FriendDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$FriendDtoImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'user_a_id')
  final String userAId;
  @override
  @JsonKey(name: 'user_b_id')
  final String userBId;
  @override
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;

  @override
  String toString() {
    return 'FriendDto(id: $id, userAId: $userAId, userBId: $userBId, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FriendDtoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userAId, userAId) || other.userAId == userAId) &&
            (identical(other.userBId, userBId) || other.userBId == userBId) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, userAId, userBId, createdAt);

  /// Create a copy of FriendDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FriendDtoImplCopyWith<_$FriendDtoImpl> get copyWith =>
      __$$FriendDtoImplCopyWithImpl<_$FriendDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FriendDtoImplToJson(this);
  }
}

abstract class _FriendDto implements FriendDto {
  const factory _FriendDto({
    required final String id,
    @JsonKey(name: 'user_a_id') required final String userAId,
    @JsonKey(name: 'user_b_id') required final String userBId,
    @JsonKey(name: 'created_at') final DateTime? createdAt,
  }) = _$FriendDtoImpl;

  factory _FriendDto.fromJson(Map<String, dynamic> json) =
      _$FriendDtoImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'user_a_id')
  String get userAId;
  @override
  @JsonKey(name: 'user_b_id')
  String get userBId;
  @override
  @JsonKey(name: 'created_at')
  DateTime? get createdAt;

  /// Create a copy of FriendDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FriendDtoImplCopyWith<_$FriendDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
