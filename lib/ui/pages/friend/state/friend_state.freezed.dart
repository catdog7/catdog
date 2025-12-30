// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'friend_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$FriendState {
  bool get isLoading => throw _privateConstructorUsedError;
  List<FriendInfoModel> get friends => throw _privateConstructorUsedError;

  /// Create a copy of FriendState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FriendStateCopyWith<FriendState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FriendStateCopyWith<$Res> {
  factory $FriendStateCopyWith(
    FriendState value,
    $Res Function(FriendState) then,
  ) = _$FriendStateCopyWithImpl<$Res, FriendState>;
  @useResult
  $Res call({bool isLoading, List<FriendInfoModel> friends});
}

/// @nodoc
class _$FriendStateCopyWithImpl<$Res, $Val extends FriendState>
    implements $FriendStateCopyWith<$Res> {
  _$FriendStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FriendState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? isLoading = null, Object? friends = null}) {
    return _then(
      _value.copyWith(
            isLoading: null == isLoading
                ? _value.isLoading
                : isLoading // ignore: cast_nullable_to_non_nullable
                      as bool,
            friends: null == friends
                ? _value.friends
                : friends // ignore: cast_nullable_to_non_nullable
                      as List<FriendInfoModel>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$FriendStateImplCopyWith<$Res>
    implements $FriendStateCopyWith<$Res> {
  factory _$$FriendStateImplCopyWith(
    _$FriendStateImpl value,
    $Res Function(_$FriendStateImpl) then,
  ) = __$$FriendStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({bool isLoading, List<FriendInfoModel> friends});
}

/// @nodoc
class __$$FriendStateImplCopyWithImpl<$Res>
    extends _$FriendStateCopyWithImpl<$Res, _$FriendStateImpl>
    implements _$$FriendStateImplCopyWith<$Res> {
  __$$FriendStateImplCopyWithImpl(
    _$FriendStateImpl _value,
    $Res Function(_$FriendStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of FriendState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? isLoading = null, Object? friends = null}) {
    return _then(
      _$FriendStateImpl(
        isLoading: null == isLoading
            ? _value.isLoading
            : isLoading // ignore: cast_nullable_to_non_nullable
                  as bool,
        friends: null == friends
            ? _value._friends
            : friends // ignore: cast_nullable_to_non_nullable
                  as List<FriendInfoModel>,
      ),
    );
  }
}

/// @nodoc

class _$FriendStateImpl implements _FriendState {
  const _$FriendStateImpl({
    required this.isLoading,
    required final List<FriendInfoModel> friends,
  }) : _friends = friends;

  @override
  final bool isLoading;
  final List<FriendInfoModel> _friends;
  @override
  List<FriendInfoModel> get friends {
    if (_friends is EqualUnmodifiableListView) return _friends;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_friends);
  }

  @override
  String toString() {
    return 'FriendState(isLoading: $isLoading, friends: $friends)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FriendStateImpl &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            const DeepCollectionEquality().equals(other._friends, _friends));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    isLoading,
    const DeepCollectionEquality().hash(_friends),
  );

  /// Create a copy of FriendState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FriendStateImplCopyWith<_$FriendStateImpl> get copyWith =>
      __$$FriendStateImplCopyWithImpl<_$FriendStateImpl>(this, _$identity);
}

abstract class _FriendState implements FriendState {
  const factory _FriendState({
    required final bool isLoading,
    required final List<FriendInfoModel> friends,
  }) = _$FriendStateImpl;

  @override
  bool get isLoading;
  @override
  List<FriendInfoModel> get friends;

  /// Create a copy of FriendState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FriendStateImplCopyWith<_$FriendStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
