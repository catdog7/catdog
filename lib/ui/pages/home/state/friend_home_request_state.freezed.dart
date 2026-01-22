// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'friend_home_request_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$FriendHomeRequestState {
  bool get isLoading => throw _privateConstructorUsedError;
  bool get isFriend => throw _privateConstructorUsedError;
  bool get isSendPending => throw _privateConstructorUsedError;
  bool get isReceivePending => throw _privateConstructorUsedError;

  /// Create a copy of FriendHomeRequestState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FriendHomeRequestStateCopyWith<FriendHomeRequestState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FriendHomeRequestStateCopyWith<$Res> {
  factory $FriendHomeRequestStateCopyWith(
    FriendHomeRequestState value,
    $Res Function(FriendHomeRequestState) then,
  ) = _$FriendHomeRequestStateCopyWithImpl<$Res, FriendHomeRequestState>;
  @useResult
  $Res call({
    bool isLoading,
    bool isFriend,
    bool isSendPending,
    bool isReceivePending,
  });
}

/// @nodoc
class _$FriendHomeRequestStateCopyWithImpl<
  $Res,
  $Val extends FriendHomeRequestState
>
    implements $FriendHomeRequestStateCopyWith<$Res> {
  _$FriendHomeRequestStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FriendHomeRequestState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isLoading = null,
    Object? isFriend = null,
    Object? isSendPending = null,
    Object? isReceivePending = null,
  }) {
    return _then(
      _value.copyWith(
            isLoading: null == isLoading
                ? _value.isLoading
                : isLoading // ignore: cast_nullable_to_non_nullable
                      as bool,
            isFriend: null == isFriend
                ? _value.isFriend
                : isFriend // ignore: cast_nullable_to_non_nullable
                      as bool,
            isSendPending: null == isSendPending
                ? _value.isSendPending
                : isSendPending // ignore: cast_nullable_to_non_nullable
                      as bool,
            isReceivePending: null == isReceivePending
                ? _value.isReceivePending
                : isReceivePending // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$FriendHomeRequestStateImplCopyWith<$Res>
    implements $FriendHomeRequestStateCopyWith<$Res> {
  factory _$$FriendHomeRequestStateImplCopyWith(
    _$FriendHomeRequestStateImpl value,
    $Res Function(_$FriendHomeRequestStateImpl) then,
  ) = __$$FriendHomeRequestStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    bool isLoading,
    bool isFriend,
    bool isSendPending,
    bool isReceivePending,
  });
}

/// @nodoc
class __$$FriendHomeRequestStateImplCopyWithImpl<$Res>
    extends
        _$FriendHomeRequestStateCopyWithImpl<$Res, _$FriendHomeRequestStateImpl>
    implements _$$FriendHomeRequestStateImplCopyWith<$Res> {
  __$$FriendHomeRequestStateImplCopyWithImpl(
    _$FriendHomeRequestStateImpl _value,
    $Res Function(_$FriendHomeRequestStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of FriendHomeRequestState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isLoading = null,
    Object? isFriend = null,
    Object? isSendPending = null,
    Object? isReceivePending = null,
  }) {
    return _then(
      _$FriendHomeRequestStateImpl(
        isLoading: null == isLoading
            ? _value.isLoading
            : isLoading // ignore: cast_nullable_to_non_nullable
                  as bool,
        isFriend: null == isFriend
            ? _value.isFriend
            : isFriend // ignore: cast_nullable_to_non_nullable
                  as bool,
        isSendPending: null == isSendPending
            ? _value.isSendPending
            : isSendPending // ignore: cast_nullable_to_non_nullable
                  as bool,
        isReceivePending: null == isReceivePending
            ? _value.isReceivePending
            : isReceivePending // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc

class _$FriendHomeRequestStateImpl implements _FriendHomeRequestState {
  const _$FriendHomeRequestStateImpl({
    required this.isLoading,
    required this.isFriend,
    required this.isSendPending,
    required this.isReceivePending,
  });

  @override
  final bool isLoading;
  @override
  final bool isFriend;
  @override
  final bool isSendPending;
  @override
  final bool isReceivePending;

  @override
  String toString() {
    return 'FriendHomeRequestState(isLoading: $isLoading, isFriend: $isFriend, isSendPending: $isSendPending, isReceivePending: $isReceivePending)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FriendHomeRequestStateImpl &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.isFriend, isFriend) ||
                other.isFriend == isFriend) &&
            (identical(other.isSendPending, isSendPending) ||
                other.isSendPending == isSendPending) &&
            (identical(other.isReceivePending, isReceivePending) ||
                other.isReceivePending == isReceivePending));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    isLoading,
    isFriend,
    isSendPending,
    isReceivePending,
  );

  /// Create a copy of FriendHomeRequestState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FriendHomeRequestStateImplCopyWith<_$FriendHomeRequestStateImpl>
  get copyWith =>
      __$$FriendHomeRequestStateImplCopyWithImpl<_$FriendHomeRequestStateImpl>(
        this,
        _$identity,
      );
}

abstract class _FriendHomeRequestState implements FriendHomeRequestState {
  const factory _FriendHomeRequestState({
    required final bool isLoading,
    required final bool isFriend,
    required final bool isSendPending,
    required final bool isReceivePending,
  }) = _$FriendHomeRequestStateImpl;

  @override
  bool get isLoading;
  @override
  bool get isFriend;
  @override
  bool get isSendPending;
  @override
  bool get isReceivePending;

  /// Create a copy of FriendHomeRequestState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FriendHomeRequestStateImplCopyWith<_$FriendHomeRequestStateImpl>
  get copyWith => throw _privateConstructorUsedError;
}
