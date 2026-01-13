// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'mypage_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$MypageState {
  bool get isLoading => throw _privateConstructorUsedError;
  String? get nickname => throw _privateConstructorUsedError;
  String? get profileImageUrl => throw _privateConstructorUsedError;
  String? get inviteCode => throw _privateConstructorUsedError;
  List<FeedDto> get myFeeds => throw _privateConstructorUsedError; // 내가 쓴 글 목록
  String? get errorMessage => throw _privateConstructorUsedError;

  /// Create a copy of MypageState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MypageStateCopyWith<MypageState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MypageStateCopyWith<$Res> {
  factory $MypageStateCopyWith(
    MypageState value,
    $Res Function(MypageState) then,
  ) = _$MypageStateCopyWithImpl<$Res, MypageState>;
  @useResult
  $Res call({
    bool isLoading,
    String? nickname,
    String? profileImageUrl,
    String? inviteCode,
    List<FeedDto> myFeeds,
    String? errorMessage,
  });
}

/// @nodoc
class _$MypageStateCopyWithImpl<$Res, $Val extends MypageState>
    implements $MypageStateCopyWith<$Res> {
  _$MypageStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MypageState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isLoading = null,
    Object? nickname = freezed,
    Object? profileImageUrl = freezed,
    Object? inviteCode = freezed,
    Object? myFeeds = null,
    Object? errorMessage = freezed,
  }) {
    return _then(
      _value.copyWith(
            isLoading: null == isLoading
                ? _value.isLoading
                : isLoading // ignore: cast_nullable_to_non_nullable
                      as bool,
            nickname: freezed == nickname
                ? _value.nickname
                : nickname // ignore: cast_nullable_to_non_nullable
                      as String?,
            profileImageUrl: freezed == profileImageUrl
                ? _value.profileImageUrl
                : profileImageUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
            inviteCode: freezed == inviteCode
                ? _value.inviteCode
                : inviteCode // ignore: cast_nullable_to_non_nullable
                      as String?,
            myFeeds: null == myFeeds
                ? _value.myFeeds
                : myFeeds // ignore: cast_nullable_to_non_nullable
                      as List<FeedDto>,
            errorMessage: freezed == errorMessage
                ? _value.errorMessage
                : errorMessage // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$MypageStateImplCopyWith<$Res>
    implements $MypageStateCopyWith<$Res> {
  factory _$$MypageStateImplCopyWith(
    _$MypageStateImpl value,
    $Res Function(_$MypageStateImpl) then,
  ) = __$$MypageStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    bool isLoading,
    String? nickname,
    String? profileImageUrl,
    String? inviteCode,
    List<FeedDto> myFeeds,
    String? errorMessage,
  });
}

/// @nodoc
class __$$MypageStateImplCopyWithImpl<$Res>
    extends _$MypageStateCopyWithImpl<$Res, _$MypageStateImpl>
    implements _$$MypageStateImplCopyWith<$Res> {
  __$$MypageStateImplCopyWithImpl(
    _$MypageStateImpl _value,
    $Res Function(_$MypageStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of MypageState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isLoading = null,
    Object? nickname = freezed,
    Object? profileImageUrl = freezed,
    Object? inviteCode = freezed,
    Object? myFeeds = null,
    Object? errorMessage = freezed,
  }) {
    return _then(
      _$MypageStateImpl(
        isLoading: null == isLoading
            ? _value.isLoading
            : isLoading // ignore: cast_nullable_to_non_nullable
                  as bool,
        nickname: freezed == nickname
            ? _value.nickname
            : nickname // ignore: cast_nullable_to_non_nullable
                  as String?,
        profileImageUrl: freezed == profileImageUrl
            ? _value.profileImageUrl
            : profileImageUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
        inviteCode: freezed == inviteCode
            ? _value.inviteCode
            : inviteCode // ignore: cast_nullable_to_non_nullable
                  as String?,
        myFeeds: null == myFeeds
            ? _value._myFeeds
            : myFeeds // ignore: cast_nullable_to_non_nullable
                  as List<FeedDto>,
        errorMessage: freezed == errorMessage
            ? _value.errorMessage
            : errorMessage // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc

class _$MypageStateImpl implements _MypageState {
  const _$MypageStateImpl({
    this.isLoading = false,
    this.nickname,
    this.profileImageUrl,
    this.inviteCode,
    final List<FeedDto> myFeeds = const [],
    this.errorMessage,
  }) : _myFeeds = myFeeds;

  @override
  @JsonKey()
  final bool isLoading;
  @override
  final String? nickname;
  @override
  final String? profileImageUrl;
  @override
  final String? inviteCode;
  final List<FeedDto> _myFeeds;
  @override
  @JsonKey()
  List<FeedDto> get myFeeds {
    if (_myFeeds is EqualUnmodifiableListView) return _myFeeds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_myFeeds);
  }

  // 내가 쓴 글 목록
  @override
  final String? errorMessage;

  @override
  String toString() {
    return 'MypageState(isLoading: $isLoading, nickname: $nickname, profileImageUrl: $profileImageUrl, inviteCode: $inviteCode, myFeeds: $myFeeds, errorMessage: $errorMessage)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MypageStateImpl &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.nickname, nickname) ||
                other.nickname == nickname) &&
            (identical(other.profileImageUrl, profileImageUrl) ||
                other.profileImageUrl == profileImageUrl) &&
            (identical(other.inviteCode, inviteCode) ||
                other.inviteCode == inviteCode) &&
            const DeepCollectionEquality().equals(other._myFeeds, _myFeeds) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    isLoading,
    nickname,
    profileImageUrl,
    inviteCode,
    const DeepCollectionEquality().hash(_myFeeds),
    errorMessage,
  );

  /// Create a copy of MypageState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MypageStateImplCopyWith<_$MypageStateImpl> get copyWith =>
      __$$MypageStateImplCopyWithImpl<_$MypageStateImpl>(this, _$identity);
}

abstract class _MypageState implements MypageState {
  const factory _MypageState({
    final bool isLoading,
    final String? nickname,
    final String? profileImageUrl,
    final String? inviteCode,
    final List<FeedDto> myFeeds,
    final String? errorMessage,
  }) = _$MypageStateImpl;

  @override
  bool get isLoading;
  @override
  String? get nickname;
  @override
  String? get profileImageUrl;
  @override
  String? get inviteCode;
  @override
  List<FeedDto> get myFeeds; // 내가 쓴 글 목록
  @override
  String? get errorMessage;

  /// Create a copy of MypageState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MypageStateImplCopyWith<_$MypageStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
