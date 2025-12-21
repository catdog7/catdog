// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'follow_request_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$FollowRequestModel {
  String get id => throw _privateConstructorUsedError;
  String get fromUserId => throw _privateConstructorUsedError;
  String get toUserId => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  String get type => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  /// Create a copy of FollowRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FollowRequestModelCopyWith<FollowRequestModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FollowRequestModelCopyWith<$Res> {
  factory $FollowRequestModelCopyWith(
    FollowRequestModel value,
    $Res Function(FollowRequestModel) then,
  ) = _$FollowRequestModelCopyWithImpl<$Res, FollowRequestModel>;
  @useResult
  $Res call({
    String id,
    String fromUserId,
    String toUserId,
    String status,
    String type,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
}

/// @nodoc
class _$FollowRequestModelCopyWithImpl<$Res, $Val extends FollowRequestModel>
    implements $FollowRequestModelCopyWith<$Res> {
  _$FollowRequestModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FollowRequestModel
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
abstract class _$$FollowRequestModelImplCopyWith<$Res>
    implements $FollowRequestModelCopyWith<$Res> {
  factory _$$FollowRequestModelImplCopyWith(
    _$FollowRequestModelImpl value,
    $Res Function(_$FollowRequestModelImpl) then,
  ) = __$$FollowRequestModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String fromUserId,
    String toUserId,
    String status,
    String type,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
}

/// @nodoc
class __$$FollowRequestModelImplCopyWithImpl<$Res>
    extends _$FollowRequestModelCopyWithImpl<$Res, _$FollowRequestModelImpl>
    implements _$$FollowRequestModelImplCopyWith<$Res> {
  __$$FollowRequestModelImplCopyWithImpl(
    _$FollowRequestModelImpl _value,
    $Res Function(_$FollowRequestModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of FollowRequestModel
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
      _$FollowRequestModelImpl(
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

class _$FollowRequestModelImpl implements _FollowRequestModel {
  const _$FollowRequestModelImpl({
    required this.id,
    required this.fromUserId,
    required this.toUserId,
    this.status = 'PENDING',
    this.type = 'FRIEND',
    this.createdAt,
    this.updatedAt,
  });

  @override
  final String id;
  @override
  final String fromUserId;
  @override
  final String toUserId;
  @override
  @JsonKey()
  final String status;
  @override
  @JsonKey()
  final String type;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'FollowRequestModel(id: $id, fromUserId: $fromUserId, toUserId: $toUserId, status: $status, type: $type, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FollowRequestModelImpl &&
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

  /// Create a copy of FollowRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FollowRequestModelImplCopyWith<_$FollowRequestModelImpl> get copyWith =>
      __$$FollowRequestModelImplCopyWithImpl<_$FollowRequestModelImpl>(
        this,
        _$identity,
      );
}

abstract class _FollowRequestModel implements FollowRequestModel {
  const factory _FollowRequestModel({
    required final String id,
    required final String fromUserId,
    required final String toUserId,
    final String status,
    final String type,
    final DateTime? createdAt,
    final DateTime? updatedAt,
  }) = _$FollowRequestModelImpl;

  @override
  String get id;
  @override
  String get fromUserId;
  @override
  String get toUserId;
  @override
  String get status;
  @override
  String get type;
  @override
  DateTime? get createdAt;
  @override
  DateTime? get updatedAt;

  /// Create a copy of FollowRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FollowRequestModelImplCopyWith<_$FollowRequestModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
