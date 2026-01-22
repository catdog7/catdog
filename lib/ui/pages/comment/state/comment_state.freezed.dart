// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'comment_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$CommentState {
  bool get isLoading => throw _privateConstructorUsedError;
  UserModel? get myInfo => throw _privateConstructorUsedError;
  String get feedId => throw _privateConstructorUsedError;
  List<CommentInfoModel> get comments => throw _privateConstructorUsedError;

  /// Create a copy of CommentState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CommentStateCopyWith<CommentState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CommentStateCopyWith<$Res> {
  factory $CommentStateCopyWith(
    CommentState value,
    $Res Function(CommentState) then,
  ) = _$CommentStateCopyWithImpl<$Res, CommentState>;
  @useResult
  $Res call({
    bool isLoading,
    UserModel? myInfo,
    String feedId,
    List<CommentInfoModel> comments,
  });

  $UserModelCopyWith<$Res>? get myInfo;
}

/// @nodoc
class _$CommentStateCopyWithImpl<$Res, $Val extends CommentState>
    implements $CommentStateCopyWith<$Res> {
  _$CommentStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CommentState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isLoading = null,
    Object? myInfo = freezed,
    Object? feedId = null,
    Object? comments = null,
  }) {
    return _then(
      _value.copyWith(
            isLoading: null == isLoading
                ? _value.isLoading
                : isLoading // ignore: cast_nullable_to_non_nullable
                      as bool,
            myInfo: freezed == myInfo
                ? _value.myInfo
                : myInfo // ignore: cast_nullable_to_non_nullable
                      as UserModel?,
            feedId: null == feedId
                ? _value.feedId
                : feedId // ignore: cast_nullable_to_non_nullable
                      as String,
            comments: null == comments
                ? _value.comments
                : comments // ignore: cast_nullable_to_non_nullable
                      as List<CommentInfoModel>,
          )
          as $Val,
    );
  }

  /// Create a copy of CommentState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $UserModelCopyWith<$Res>? get myInfo {
    if (_value.myInfo == null) {
      return null;
    }

    return $UserModelCopyWith<$Res>(_value.myInfo!, (value) {
      return _then(_value.copyWith(myInfo: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$CommentStateImplCopyWith<$Res>
    implements $CommentStateCopyWith<$Res> {
  factory _$$CommentStateImplCopyWith(
    _$CommentStateImpl value,
    $Res Function(_$CommentStateImpl) then,
  ) = __$$CommentStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    bool isLoading,
    UserModel? myInfo,
    String feedId,
    List<CommentInfoModel> comments,
  });

  @override
  $UserModelCopyWith<$Res>? get myInfo;
}

/// @nodoc
class __$$CommentStateImplCopyWithImpl<$Res>
    extends _$CommentStateCopyWithImpl<$Res, _$CommentStateImpl>
    implements _$$CommentStateImplCopyWith<$Res> {
  __$$CommentStateImplCopyWithImpl(
    _$CommentStateImpl _value,
    $Res Function(_$CommentStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CommentState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isLoading = null,
    Object? myInfo = freezed,
    Object? feedId = null,
    Object? comments = null,
  }) {
    return _then(
      _$CommentStateImpl(
        isLoading: null == isLoading
            ? _value.isLoading
            : isLoading // ignore: cast_nullable_to_non_nullable
                  as bool,
        myInfo: freezed == myInfo
            ? _value.myInfo
            : myInfo // ignore: cast_nullable_to_non_nullable
                  as UserModel?,
        feedId: null == feedId
            ? _value.feedId
            : feedId // ignore: cast_nullable_to_non_nullable
                  as String,
        comments: null == comments
            ? _value._comments
            : comments // ignore: cast_nullable_to_non_nullable
                  as List<CommentInfoModel>,
      ),
    );
  }
}

/// @nodoc

class _$CommentStateImpl implements _CommentState {
  const _$CommentStateImpl({
    required this.isLoading,
    this.myInfo,
    required this.feedId,
    required final List<CommentInfoModel> comments,
  }) : _comments = comments;

  @override
  final bool isLoading;
  @override
  final UserModel? myInfo;
  @override
  final String feedId;
  final List<CommentInfoModel> _comments;
  @override
  List<CommentInfoModel> get comments {
    if (_comments is EqualUnmodifiableListView) return _comments;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_comments);
  }

  @override
  String toString() {
    return 'CommentState(isLoading: $isLoading, myInfo: $myInfo, feedId: $feedId, comments: $comments)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CommentStateImpl &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.myInfo, myInfo) || other.myInfo == myInfo) &&
            (identical(other.feedId, feedId) || other.feedId == feedId) &&
            const DeepCollectionEquality().equals(other._comments, _comments));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    isLoading,
    myInfo,
    feedId,
    const DeepCollectionEquality().hash(_comments),
  );

  /// Create a copy of CommentState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CommentStateImplCopyWith<_$CommentStateImpl> get copyWith =>
      __$$CommentStateImplCopyWithImpl<_$CommentStateImpl>(this, _$identity);
}

abstract class _CommentState implements CommentState {
  const factory _CommentState({
    required final bool isLoading,
    final UserModel? myInfo,
    required final String feedId,
    required final List<CommentInfoModel> comments,
  }) = _$CommentStateImpl;

  @override
  bool get isLoading;
  @override
  UserModel? get myInfo;
  @override
  String get feedId;
  @override
  List<CommentInfoModel> get comments;

  /// Create a copy of CommentState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CommentStateImplCopyWith<_$CommentStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
