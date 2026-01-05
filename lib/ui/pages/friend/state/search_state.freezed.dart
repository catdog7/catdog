// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'search_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$SearchState {
  bool get isLoading => throw _privateConstructorUsedError;
  List<FriendInfoModel> get users => throw _privateConstructorUsedError;

  /// Create a copy of SearchState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SearchStateCopyWith<SearchState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SearchStateCopyWith<$Res> {
  factory $SearchStateCopyWith(
    SearchState value,
    $Res Function(SearchState) then,
  ) = _$SearchStateCopyWithImpl<$Res, SearchState>;
  @useResult
  $Res call({bool isLoading, List<FriendInfoModel> users});
}

/// @nodoc
class _$SearchStateCopyWithImpl<$Res, $Val extends SearchState>
    implements $SearchStateCopyWith<$Res> {
  _$SearchStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SearchState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? isLoading = null, Object? users = null}) {
    return _then(
      _value.copyWith(
            isLoading: null == isLoading
                ? _value.isLoading
                : isLoading // ignore: cast_nullable_to_non_nullable
                      as bool,
            users: null == users
                ? _value.users
                : users // ignore: cast_nullable_to_non_nullable
                      as List<FriendInfoModel>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$SearchStateImplCopyWith<$Res>
    implements $SearchStateCopyWith<$Res> {
  factory _$$SearchStateImplCopyWith(
    _$SearchStateImpl value,
    $Res Function(_$SearchStateImpl) then,
  ) = __$$SearchStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({bool isLoading, List<FriendInfoModel> users});
}

/// @nodoc
class __$$SearchStateImplCopyWithImpl<$Res>
    extends _$SearchStateCopyWithImpl<$Res, _$SearchStateImpl>
    implements _$$SearchStateImplCopyWith<$Res> {
  __$$SearchStateImplCopyWithImpl(
    _$SearchStateImpl _value,
    $Res Function(_$SearchStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SearchState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? isLoading = null, Object? users = null}) {
    return _then(
      _$SearchStateImpl(
        isLoading: null == isLoading
            ? _value.isLoading
            : isLoading // ignore: cast_nullable_to_non_nullable
                  as bool,
        users: null == users
            ? _value._users
            : users // ignore: cast_nullable_to_non_nullable
                  as List<FriendInfoModel>,
      ),
    );
  }
}

/// @nodoc

class _$SearchStateImpl implements _SearchState {
  const _$SearchStateImpl({
    required this.isLoading,
    required final List<FriendInfoModel> users,
  }) : _users = users;

  @override
  final bool isLoading;
  final List<FriendInfoModel> _users;
  @override
  List<FriendInfoModel> get users {
    if (_users is EqualUnmodifiableListView) return _users;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_users);
  }

  @override
  String toString() {
    return 'SearchState(isLoading: $isLoading, users: $users)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SearchStateImpl &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            const DeepCollectionEquality().equals(other._users, _users));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    isLoading,
    const DeepCollectionEquality().hash(_users),
  );

  /// Create a copy of SearchState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SearchStateImplCopyWith<_$SearchStateImpl> get copyWith =>
      __$$SearchStateImplCopyWithImpl<_$SearchStateImpl>(this, _$identity);
}

abstract class _SearchState implements SearchState {
  const factory _SearchState({
    required final bool isLoading,
    required final List<FriendInfoModel> users,
  }) = _$SearchStateImpl;

  @override
  bool get isLoading;
  @override
  List<FriendInfoModel> get users;

  /// Create a copy of SearchState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SearchStateImplCopyWith<_$SearchStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
