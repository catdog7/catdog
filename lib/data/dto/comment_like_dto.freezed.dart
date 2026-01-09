// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'comment_like_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

CommentLikeDto _$CommentLikeDtoFromJson(Map<String, dynamic> json) {
  return _CommentLikeDto.fromJson(json);
}

/// @nodoc
mixin _$CommentLikeDto {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'comment_id')
  String get commentId => throw _privateConstructorUsedError;
  @JsonKey(name: 'user_id')
  String get userId => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// Serializes this CommentLikeDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CommentLikeDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CommentLikeDtoCopyWith<CommentLikeDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CommentLikeDtoCopyWith<$Res> {
  factory $CommentLikeDtoCopyWith(
    CommentLikeDto value,
    $Res Function(CommentLikeDto) then,
  ) = _$CommentLikeDtoCopyWithImpl<$Res, CommentLikeDto>;
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'comment_id') String commentId,
    @JsonKey(name: 'user_id') String userId,
    @JsonKey(name: 'created_at') DateTime createdAt,
  });
}

/// @nodoc
class _$CommentLikeDtoCopyWithImpl<$Res, $Val extends CommentLikeDto>
    implements $CommentLikeDtoCopyWith<$Res> {
  _$CommentLikeDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CommentLikeDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? commentId = null,
    Object? userId = null,
    Object? createdAt = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            commentId: null == commentId
                ? _value.commentId
                : commentId // ignore: cast_nullable_to_non_nullable
                      as String,
            userId: null == userId
                ? _value.userId
                : userId // ignore: cast_nullable_to_non_nullable
                      as String,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$CommentLikeDtoImplCopyWith<$Res>
    implements $CommentLikeDtoCopyWith<$Res> {
  factory _$$CommentLikeDtoImplCopyWith(
    _$CommentLikeDtoImpl value,
    $Res Function(_$CommentLikeDtoImpl) then,
  ) = __$$CommentLikeDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'comment_id') String commentId,
    @JsonKey(name: 'user_id') String userId,
    @JsonKey(name: 'created_at') DateTime createdAt,
  });
}

/// @nodoc
class __$$CommentLikeDtoImplCopyWithImpl<$Res>
    extends _$CommentLikeDtoCopyWithImpl<$Res, _$CommentLikeDtoImpl>
    implements _$$CommentLikeDtoImplCopyWith<$Res> {
  __$$CommentLikeDtoImplCopyWithImpl(
    _$CommentLikeDtoImpl _value,
    $Res Function(_$CommentLikeDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CommentLikeDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? commentId = null,
    Object? userId = null,
    Object? createdAt = null,
  }) {
    return _then(
      _$CommentLikeDtoImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        commentId: null == commentId
            ? _value.commentId
            : commentId // ignore: cast_nullable_to_non_nullable
                  as String,
        userId: null == userId
            ? _value.userId
            : userId // ignore: cast_nullable_to_non_nullable
                  as String,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$CommentLikeDtoImpl implements _CommentLikeDto {
  const _$CommentLikeDtoImpl({
    required this.id,
    @JsonKey(name: 'comment_id') required this.commentId,
    @JsonKey(name: 'user_id') required this.userId,
    @JsonKey(name: 'created_at') required this.createdAt,
  });

  factory _$CommentLikeDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$CommentLikeDtoImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'comment_id')
  final String commentId;
  @override
  @JsonKey(name: 'user_id')
  final String userId;
  @override
  @JsonKey(name: 'created_at')
  final DateTime createdAt;

  @override
  String toString() {
    return 'CommentLikeDto(id: $id, commentId: $commentId, userId: $userId, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CommentLikeDtoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.commentId, commentId) ||
                other.commentId == commentId) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, commentId, userId, createdAt);

  /// Create a copy of CommentLikeDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CommentLikeDtoImplCopyWith<_$CommentLikeDtoImpl> get copyWith =>
      __$$CommentLikeDtoImplCopyWithImpl<_$CommentLikeDtoImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$CommentLikeDtoImplToJson(this);
  }
}

abstract class _CommentLikeDto implements CommentLikeDto {
  const factory _CommentLikeDto({
    required final String id,
    @JsonKey(name: 'comment_id') required final String commentId,
    @JsonKey(name: 'user_id') required final String userId,
    @JsonKey(name: 'created_at') required final DateTime createdAt,
  }) = _$CommentLikeDtoImpl;

  factory _CommentLikeDto.fromJson(Map<String, dynamic> json) =
      _$CommentLikeDtoImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'comment_id')
  String get commentId;
  @override
  @JsonKey(name: 'user_id')
  String get userId;
  @override
  @JsonKey(name: 'created_at')
  DateTime get createdAt;

  /// Create a copy of CommentLikeDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CommentLikeDtoImplCopyWith<_$CommentLikeDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
