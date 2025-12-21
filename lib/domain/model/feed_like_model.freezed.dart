// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'feed_like_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$FeedLikeModel {
  String get id => throw _privateConstructorUsedError;
  String get feedId => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;

  /// Create a copy of FeedLikeModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FeedLikeModelCopyWith<FeedLikeModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FeedLikeModelCopyWith<$Res> {
  factory $FeedLikeModelCopyWith(
    FeedLikeModel value,
    $Res Function(FeedLikeModel) then,
  ) = _$FeedLikeModelCopyWithImpl<$Res, FeedLikeModel>;
  @useResult
  $Res call({String id, String feedId, String userId, DateTime? createdAt});
}

/// @nodoc
class _$FeedLikeModelCopyWithImpl<$Res, $Val extends FeedLikeModel>
    implements $FeedLikeModelCopyWith<$Res> {
  _$FeedLikeModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FeedLikeModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? feedId = null,
    Object? userId = null,
    Object? createdAt = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            feedId: null == feedId
                ? _value.feedId
                : feedId // ignore: cast_nullable_to_non_nullable
                      as String,
            userId: null == userId
                ? _value.userId
                : userId // ignore: cast_nullable_to_non_nullable
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
abstract class _$$FeedLikeModelImplCopyWith<$Res>
    implements $FeedLikeModelCopyWith<$Res> {
  factory _$$FeedLikeModelImplCopyWith(
    _$FeedLikeModelImpl value,
    $Res Function(_$FeedLikeModelImpl) then,
  ) = __$$FeedLikeModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id, String feedId, String userId, DateTime? createdAt});
}

/// @nodoc
class __$$FeedLikeModelImplCopyWithImpl<$Res>
    extends _$FeedLikeModelCopyWithImpl<$Res, _$FeedLikeModelImpl>
    implements _$$FeedLikeModelImplCopyWith<$Res> {
  __$$FeedLikeModelImplCopyWithImpl(
    _$FeedLikeModelImpl _value,
    $Res Function(_$FeedLikeModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of FeedLikeModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? feedId = null,
    Object? userId = null,
    Object? createdAt = freezed,
  }) {
    return _then(
      _$FeedLikeModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        feedId: null == feedId
            ? _value.feedId
            : feedId // ignore: cast_nullable_to_non_nullable
                  as String,
        userId: null == userId
            ? _value.userId
            : userId // ignore: cast_nullable_to_non_nullable
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

class _$FeedLikeModelImpl implements _FeedLikeModel {
  const _$FeedLikeModelImpl({
    required this.id,
    required this.feedId,
    required this.userId,
    this.createdAt,
  });

  @override
  final String id;
  @override
  final String feedId;
  @override
  final String userId;
  @override
  final DateTime? createdAt;

  @override
  String toString() {
    return 'FeedLikeModel(id: $id, feedId: $feedId, userId: $userId, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FeedLikeModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.feedId, feedId) || other.feedId == feedId) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @override
  int get hashCode => Object.hash(runtimeType, id, feedId, userId, createdAt);

  /// Create a copy of FeedLikeModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FeedLikeModelImplCopyWith<_$FeedLikeModelImpl> get copyWith =>
      __$$FeedLikeModelImplCopyWithImpl<_$FeedLikeModelImpl>(this, _$identity);
}

abstract class _FeedLikeModel implements FeedLikeModel {
  const factory _FeedLikeModel({
    required final String id,
    required final String feedId,
    required final String userId,
    final DateTime? createdAt,
  }) = _$FeedLikeModelImpl;

  @override
  String get id;
  @override
  String get feedId;
  @override
  String get userId;
  @override
  DateTime? get createdAt;

  /// Create a copy of FeedLikeModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FeedLikeModelImplCopyWith<_$FeedLikeModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
