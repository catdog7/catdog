// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'comment_info_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$CommentInfoModel {
  String get userId => throw _privateConstructorUsedError;
  String get nickname => throw _privateConstructorUsedError;
  String get content => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  bool get isLike => throw _privateConstructorUsedError;
  int get likeCount => throw _privateConstructorUsedError;
  String? get profileImageUrl => throw _privateConstructorUsedError;

  /// Create a copy of CommentInfoModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CommentInfoModelCopyWith<CommentInfoModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CommentInfoModelCopyWith<$Res> {
  factory $CommentInfoModelCopyWith(
    CommentInfoModel value,
    $Res Function(CommentInfoModel) then,
  ) = _$CommentInfoModelCopyWithImpl<$Res, CommentInfoModel>;
  @useResult
  $Res call({
    String userId,
    String nickname,
    String content,
    DateTime? createdAt,
    bool isLike,
    int likeCount,
    String? profileImageUrl,
  });
}

/// @nodoc
class _$CommentInfoModelCopyWithImpl<$Res, $Val extends CommentInfoModel>
    implements $CommentInfoModelCopyWith<$Res> {
  _$CommentInfoModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CommentInfoModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? nickname = null,
    Object? content = null,
    Object? createdAt = freezed,
    Object? isLike = null,
    Object? likeCount = null,
    Object? profileImageUrl = freezed,
  }) {
    return _then(
      _value.copyWith(
            userId: null == userId
                ? _value.userId
                : userId // ignore: cast_nullable_to_non_nullable
                      as String,
            nickname: null == nickname
                ? _value.nickname
                : nickname // ignore: cast_nullable_to_non_nullable
                      as String,
            content: null == content
                ? _value.content
                : content // ignore: cast_nullable_to_non_nullable
                      as String,
            createdAt: freezed == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            isLike: null == isLike
                ? _value.isLike
                : isLike // ignore: cast_nullable_to_non_nullable
                      as bool,
            likeCount: null == likeCount
                ? _value.likeCount
                : likeCount // ignore: cast_nullable_to_non_nullable
                      as int,
            profileImageUrl: freezed == profileImageUrl
                ? _value.profileImageUrl
                : profileImageUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$CommentInfoModelImplCopyWith<$Res>
    implements $CommentInfoModelCopyWith<$Res> {
  factory _$$CommentInfoModelImplCopyWith(
    _$CommentInfoModelImpl value,
    $Res Function(_$CommentInfoModelImpl) then,
  ) = __$$CommentInfoModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String userId,
    String nickname,
    String content,
    DateTime? createdAt,
    bool isLike,
    int likeCount,
    String? profileImageUrl,
  });
}

/// @nodoc
class __$$CommentInfoModelImplCopyWithImpl<$Res>
    extends _$CommentInfoModelCopyWithImpl<$Res, _$CommentInfoModelImpl>
    implements _$$CommentInfoModelImplCopyWith<$Res> {
  __$$CommentInfoModelImplCopyWithImpl(
    _$CommentInfoModelImpl _value,
    $Res Function(_$CommentInfoModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CommentInfoModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? nickname = null,
    Object? content = null,
    Object? createdAt = freezed,
    Object? isLike = null,
    Object? likeCount = null,
    Object? profileImageUrl = freezed,
  }) {
    return _then(
      _$CommentInfoModelImpl(
        userId: null == userId
            ? _value.userId
            : userId // ignore: cast_nullable_to_non_nullable
                  as String,
        nickname: null == nickname
            ? _value.nickname
            : nickname // ignore: cast_nullable_to_non_nullable
                  as String,
        content: null == content
            ? _value.content
            : content // ignore: cast_nullable_to_non_nullable
                  as String,
        createdAt: freezed == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        isLike: null == isLike
            ? _value.isLike
            : isLike // ignore: cast_nullable_to_non_nullable
                  as bool,
        likeCount: null == likeCount
            ? _value.likeCount
            : likeCount // ignore: cast_nullable_to_non_nullable
                  as int,
        profileImageUrl: freezed == profileImageUrl
            ? _value.profileImageUrl
            : profileImageUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc

class _$CommentInfoModelImpl implements _CommentInfoModel {
  const _$CommentInfoModelImpl({
    required this.userId,
    required this.nickname,
    required this.content,
    this.createdAt,
    required this.isLike,
    required this.likeCount,
    this.profileImageUrl,
  });

  @override
  final String userId;
  @override
  final String nickname;
  @override
  final String content;
  @override
  final DateTime? createdAt;
  @override
  final bool isLike;
  @override
  final int likeCount;
  @override
  final String? profileImageUrl;

  @override
  String toString() {
    return 'CommentInfoModel(userId: $userId, nickname: $nickname, content: $content, createdAt: $createdAt, isLike: $isLike, likeCount: $likeCount, profileImageUrl: $profileImageUrl)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CommentInfoModelImpl &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.nickname, nickname) ||
                other.nickname == nickname) &&
            (identical(other.content, content) || other.content == content) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.isLike, isLike) || other.isLike == isLike) &&
            (identical(other.likeCount, likeCount) ||
                other.likeCount == likeCount) &&
            (identical(other.profileImageUrl, profileImageUrl) ||
                other.profileImageUrl == profileImageUrl));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    userId,
    nickname,
    content,
    createdAt,
    isLike,
    likeCount,
    profileImageUrl,
  );

  /// Create a copy of CommentInfoModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CommentInfoModelImplCopyWith<_$CommentInfoModelImpl> get copyWith =>
      __$$CommentInfoModelImplCopyWithImpl<_$CommentInfoModelImpl>(
        this,
        _$identity,
      );
}

abstract class _CommentInfoModel implements CommentInfoModel {
  const factory _CommentInfoModel({
    required final String userId,
    required final String nickname,
    required final String content,
    final DateTime? createdAt,
    required final bool isLike,
    required final int likeCount,
    final String? profileImageUrl,
  }) = _$CommentInfoModelImpl;

  @override
  String get userId;
  @override
  String get nickname;
  @override
  String get content;
  @override
  DateTime? get createdAt;
  @override
  bool get isLike;
  @override
  int get likeCount;
  @override
  String? get profileImageUrl;

  /// Create a copy of CommentInfoModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CommentInfoModelImplCopyWith<_$CommentInfoModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
