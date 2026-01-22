// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'feed_like_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

FeedLikeDto _$FeedLikeDtoFromJson(Map<String, dynamic> json) {
  return _FeedLikeDto.fromJson(json);
}

/// @nodoc
mixin _$FeedLikeDto {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'feed_id')
  String get feedId => throw _privateConstructorUsedError;
  @JsonKey(name: 'user_id')
  String get userId => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime? get createdAt => throw _privateConstructorUsedError;

  /// Serializes this FeedLikeDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of FeedLikeDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FeedLikeDtoCopyWith<FeedLikeDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FeedLikeDtoCopyWith<$Res> {
  factory $FeedLikeDtoCopyWith(
    FeedLikeDto value,
    $Res Function(FeedLikeDto) then,
  ) = _$FeedLikeDtoCopyWithImpl<$Res, FeedLikeDto>;
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'feed_id') String feedId,
    @JsonKey(name: 'user_id') String userId,
    @JsonKey(name: 'created_at') DateTime? createdAt,
  });
}

/// @nodoc
class _$FeedLikeDtoCopyWithImpl<$Res, $Val extends FeedLikeDto>
    implements $FeedLikeDtoCopyWith<$Res> {
  _$FeedLikeDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FeedLikeDto
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
abstract class _$$FeedLikeDtoImplCopyWith<$Res>
    implements $FeedLikeDtoCopyWith<$Res> {
  factory _$$FeedLikeDtoImplCopyWith(
    _$FeedLikeDtoImpl value,
    $Res Function(_$FeedLikeDtoImpl) then,
  ) = __$$FeedLikeDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'feed_id') String feedId,
    @JsonKey(name: 'user_id') String userId,
    @JsonKey(name: 'created_at') DateTime? createdAt,
  });
}

/// @nodoc
class __$$FeedLikeDtoImplCopyWithImpl<$Res>
    extends _$FeedLikeDtoCopyWithImpl<$Res, _$FeedLikeDtoImpl>
    implements _$$FeedLikeDtoImplCopyWith<$Res> {
  __$$FeedLikeDtoImplCopyWithImpl(
    _$FeedLikeDtoImpl _value,
    $Res Function(_$FeedLikeDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of FeedLikeDto
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
      _$FeedLikeDtoImpl(
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
@JsonSerializable()
class _$FeedLikeDtoImpl implements _FeedLikeDto {
  const _$FeedLikeDtoImpl({
    required this.id,
    @JsonKey(name: 'feed_id') required this.feedId,
    @JsonKey(name: 'user_id') required this.userId,
    @JsonKey(name: 'created_at') this.createdAt,
  });

  factory _$FeedLikeDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$FeedLikeDtoImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'feed_id')
  final String feedId;
  @override
  @JsonKey(name: 'user_id')
  final String userId;
  @override
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;

  @override
  String toString() {
    return 'FeedLikeDto(id: $id, feedId: $feedId, userId: $userId, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FeedLikeDtoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.feedId, feedId) || other.feedId == feedId) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, feedId, userId, createdAt);

  /// Create a copy of FeedLikeDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FeedLikeDtoImplCopyWith<_$FeedLikeDtoImpl> get copyWith =>
      __$$FeedLikeDtoImplCopyWithImpl<_$FeedLikeDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FeedLikeDtoImplToJson(this);
  }
}

abstract class _FeedLikeDto implements FeedLikeDto {
  const factory _FeedLikeDto({
    required final String id,
    @JsonKey(name: 'feed_id') required final String feedId,
    @JsonKey(name: 'user_id') required final String userId,
    @JsonKey(name: 'created_at') final DateTime? createdAt,
  }) = _$FeedLikeDtoImpl;

  factory _FeedLikeDto.fromJson(Map<String, dynamic> json) =
      _$FeedLikeDtoImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'feed_id')
  String get feedId;
  @override
  @JsonKey(name: 'user_id')
  String get userId;
  @override
  @JsonKey(name: 'created_at')
  DateTime? get createdAt;

  /// Create a copy of FeedLikeDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FeedLikeDtoImplCopyWith<_$FeedLikeDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
