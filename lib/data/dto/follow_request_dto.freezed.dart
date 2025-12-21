// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'follow_request_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

FollowRequestDto _$FollowRequestDtoFromJson(Map<String, dynamic> json) {
  return _FollowRequestDto.fromJson(json);
}

/// @nodoc
mixin _$FollowRequestDto {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'from_user_id')
  String get fromUserId => throw _privateConstructorUsedError;
  @JsonKey(name: 'to_user_id')
  String get toUserId => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  String get type => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime? get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this FollowRequestDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of FollowRequestDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FollowRequestDtoCopyWith<FollowRequestDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FollowRequestDtoCopyWith<$Res> {
  factory $FollowRequestDtoCopyWith(
    FollowRequestDto value,
    $Res Function(FollowRequestDto) then,
  ) = _$FollowRequestDtoCopyWithImpl<$Res, FollowRequestDto>;
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'from_user_id') String fromUserId,
    @JsonKey(name: 'to_user_id') String toUserId,
    String status,
    String type,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
  });
}

/// @nodoc
class _$FollowRequestDtoCopyWithImpl<$Res, $Val extends FollowRequestDto>
    implements $FollowRequestDtoCopyWith<$Res> {
  _$FollowRequestDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FollowRequestDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? fromUserId = null,
    Object? toUserId = null,
    Object? status = null,
    Object? type = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            fromUserId: null == fromUserId
                ? _value.fromUserId
                : fromUserId // ignore: cast_nullable_to_non_nullable
                      as String,
            toUserId: null == toUserId
                ? _value.toUserId
                : toUserId // ignore: cast_nullable_to_non_nullable
                      as String,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as String,
            type: null == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                      as String,
            createdAt: freezed == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            updatedAt: freezed == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$FollowRequestDtoImplCopyWith<$Res>
    implements $FollowRequestDtoCopyWith<$Res> {
  factory _$$FollowRequestDtoImplCopyWith(
    _$FollowRequestDtoImpl value,
    $Res Function(_$FollowRequestDtoImpl) then,
  ) = __$$FollowRequestDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'from_user_id') String fromUserId,
    @JsonKey(name: 'to_user_id') String toUserId,
    String status,
    String type,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
  });
}

/// @nodoc
class __$$FollowRequestDtoImplCopyWithImpl<$Res>
    extends _$FollowRequestDtoCopyWithImpl<$Res, _$FollowRequestDtoImpl>
    implements _$$FollowRequestDtoImplCopyWith<$Res> {
  __$$FollowRequestDtoImplCopyWithImpl(
    _$FollowRequestDtoImpl _value,
    $Res Function(_$FollowRequestDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of FollowRequestDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? fromUserId = null,
    Object? toUserId = null,
    Object? status = null,
    Object? type = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(
      _$FollowRequestDtoImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        fromUserId: null == fromUserId
            ? _value.fromUserId
            : fromUserId // ignore: cast_nullable_to_non_nullable
                  as String,
        toUserId: null == toUserId
            ? _value.toUserId
            : toUserId // ignore: cast_nullable_to_non_nullable
                  as String,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as String,
        type: null == type
            ? _value.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String,
        createdAt: freezed == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        updatedAt: freezed == updatedAt
            ? _value.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$FollowRequestDtoImpl implements _FollowRequestDto {
  const _$FollowRequestDtoImpl({
    required this.id,
    @JsonKey(name: 'from_user_id') required this.fromUserId,
    @JsonKey(name: 'to_user_id') required this.toUserId,
    this.status = 'PENDING',
    this.type = 'FRIEND',
    @JsonKey(name: 'created_at') this.createdAt,
    @JsonKey(name: 'updated_at') this.updatedAt,
  });

  factory _$FollowRequestDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$FollowRequestDtoImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'from_user_id')
  final String fromUserId;
  @override
  @JsonKey(name: 'to_user_id')
  final String toUserId;
  @override
  @JsonKey()
  final String status;
  @override
  @JsonKey()
  final String type;
  @override
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;
  @override
  @JsonKey(name: 'updated_at')
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'FollowRequestDto(id: $id, fromUserId: $fromUserId, toUserId: $toUserId, status: $status, type: $type, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FollowRequestDtoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.fromUserId, fromUserId) ||
                other.fromUserId == fromUserId) &&
            (identical(other.toUserId, toUserId) ||
                other.toUserId == toUserId) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    fromUserId,
    toUserId,
    status,
    type,
    createdAt,
    updatedAt,
  );

  /// Create a copy of FollowRequestDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FollowRequestDtoImplCopyWith<_$FollowRequestDtoImpl> get copyWith =>
      __$$FollowRequestDtoImplCopyWithImpl<_$FollowRequestDtoImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$FollowRequestDtoImplToJson(this);
  }
}

abstract class _FollowRequestDto implements FollowRequestDto {
  const factory _FollowRequestDto({
    required final String id,
    @JsonKey(name: 'from_user_id') required final String fromUserId,
    @JsonKey(name: 'to_user_id') required final String toUserId,
    final String status,
    final String type,
    @JsonKey(name: 'created_at') final DateTime? createdAt,
    @JsonKey(name: 'updated_at') final DateTime? updatedAt,
  }) = _$FollowRequestDtoImpl;

  factory _FollowRequestDto.fromJson(Map<String, dynamic> json) =
      _$FollowRequestDtoImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'from_user_id')
  String get fromUserId;
  @override
  @JsonKey(name: 'to_user_id')
  String get toUserId;
  @override
  String get status;
  @override
  String get type;
  @override
  @JsonKey(name: 'created_at')
  DateTime? get createdAt;
  @override
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt;

  /// Create a copy of FollowRequestDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FollowRequestDtoImplCopyWith<_$FollowRequestDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
