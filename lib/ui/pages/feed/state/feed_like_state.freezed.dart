// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'feed_like_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$FeedLikeState {
  bool get isLoading => throw _privateConstructorUsedError;
  String get feedId => throw _privateConstructorUsedError;
  int get commentCount => throw _privateConstructorUsedError;
  int get likeCount => throw _privateConstructorUsedError;
  bool get isLiked => throw _privateConstructorUsedError;

  /// Create a copy of FeedLikeState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FeedLikeStateCopyWith<FeedLikeState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FeedLikeStateCopyWith<$Res> {
  factory $FeedLikeStateCopyWith(
    FeedLikeState value,
    $Res Function(FeedLikeState) then,
  ) = _$FeedLikeStateCopyWithImpl<$Res, FeedLikeState>;
  @useResult
  $Res call({
    bool isLoading,
    String feedId,
    int commentCount,
    int likeCount,
    bool isLiked,
  });
}

/// @nodoc
class _$FeedLikeStateCopyWithImpl<$Res, $Val extends FeedLikeState>
    implements $FeedLikeStateCopyWith<$Res> {
  _$FeedLikeStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FeedLikeState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isLoading = null,
    Object? feedId = null,
    Object? commentCount = null,
    Object? likeCount = null,
    Object? isLiked = null,
  }) {
    return _then(
      _value.copyWith(
            isLoading: null == isLoading
                ? _value.isLoading
                : isLoading // ignore: cast_nullable_to_non_nullable
                      as bool,
            feedId: null == feedId
                ? _value.feedId
                : feedId // ignore: cast_nullable_to_non_nullable
                      as String,
            commentCount: null == commentCount
                ? _value.commentCount
                : commentCount // ignore: cast_nullable_to_non_nullable
                      as int,
            likeCount: null == likeCount
                ? _value.likeCount
                : likeCount // ignore: cast_nullable_to_non_nullable
                      as int,
            isLiked: null == isLiked
                ? _value.isLiked
                : isLiked // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$FeedLikeStateImplCopyWith<$Res>
    implements $FeedLikeStateCopyWith<$Res> {
  factory _$$FeedLikeStateImplCopyWith(
    _$FeedLikeStateImpl value,
    $Res Function(_$FeedLikeStateImpl) then,
  ) = __$$FeedLikeStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    bool isLoading,
    String feedId,
    int commentCount,
    int likeCount,
    bool isLiked,
  });
}

/// @nodoc
class __$$FeedLikeStateImplCopyWithImpl<$Res>
    extends _$FeedLikeStateCopyWithImpl<$Res, _$FeedLikeStateImpl>
    implements _$$FeedLikeStateImplCopyWith<$Res> {
  __$$FeedLikeStateImplCopyWithImpl(
    _$FeedLikeStateImpl _value,
    $Res Function(_$FeedLikeStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of FeedLikeState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isLoading = null,
    Object? feedId = null,
    Object? commentCount = null,
    Object? likeCount = null,
    Object? isLiked = null,
  }) {
    return _then(
      _$FeedLikeStateImpl(
        isLoading: null == isLoading
            ? _value.isLoading
            : isLoading // ignore: cast_nullable_to_non_nullable
                  as bool,
        feedId: null == feedId
            ? _value.feedId
            : feedId // ignore: cast_nullable_to_non_nullable
                  as String,
        commentCount: null == commentCount
            ? _value.commentCount
            : commentCount // ignore: cast_nullable_to_non_nullable
                  as int,
        likeCount: null == likeCount
            ? _value.likeCount
            : likeCount // ignore: cast_nullable_to_non_nullable
                  as int,
        isLiked: null == isLiked
            ? _value.isLiked
            : isLiked // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc

class _$FeedLikeStateImpl implements _FeedLikeState {
  const _$FeedLikeStateImpl({
    required this.isLoading,
    required this.feedId,
    required this.commentCount,
    required this.likeCount,
    required this.isLiked,
  });

  @override
  final bool isLoading;
  @override
  final String feedId;
  @override
  final int commentCount;
  @override
  final int likeCount;
  @override
  final bool isLiked;

  @override
  String toString() {
    return 'FeedLikeState(isLoading: $isLoading, feedId: $feedId, commentCount: $commentCount, likeCount: $likeCount, isLiked: $isLiked)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FeedLikeStateImpl &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.feedId, feedId) || other.feedId == feedId) &&
            (identical(other.commentCount, commentCount) ||
                other.commentCount == commentCount) &&
            (identical(other.likeCount, likeCount) ||
                other.likeCount == likeCount) &&
            (identical(other.isLiked, isLiked) || other.isLiked == isLiked));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    isLoading,
    feedId,
    commentCount,
    likeCount,
    isLiked,
  );

  /// Create a copy of FeedLikeState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FeedLikeStateImplCopyWith<_$FeedLikeStateImpl> get copyWith =>
      __$$FeedLikeStateImplCopyWithImpl<_$FeedLikeStateImpl>(this, _$identity);
}

abstract class _FeedLikeState implements FeedLikeState {
  const factory _FeedLikeState({
    required final bool isLoading,
    required final String feedId,
    required final int commentCount,
    required final int likeCount,
    required final bool isLiked,
  }) = _$FeedLikeStateImpl;

  @override
  bool get isLoading;
  @override
  String get feedId;
  @override
  int get commentCount;
  @override
  int get likeCount;
  @override
  bool get isLiked;

  /// Create a copy of FeedLikeState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FeedLikeStateImplCopyWith<_$FeedLikeStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
