// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'home_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$HomeState {
  List<FeedModel> get feedList => throw _privateConstructorUsedError;
  DocumentSnapshot<Object?>? get lastDocument =>
      throw _privateConstructorUsedError;
  int get currentPage => throw _privateConstructorUsedError;
  bool get isLastPage => throw _privateConstructorUsedError;
  bool get isLoading => throw _privateConstructorUsedError;
  bool get isRefreshing => throw _privateConstructorUsedError;

  /// Create a copy of HomeState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $HomeStateCopyWith<HomeState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HomeStateCopyWith<$Res> {
  factory $HomeStateCopyWith(HomeState value, $Res Function(HomeState) then) =
      _$HomeStateCopyWithImpl<$Res, HomeState>;
  @useResult
  $Res call({
    List<FeedModel> feedList,
    DocumentSnapshot<Object?>? lastDocument,
    int currentPage,
    bool isLastPage,
    bool isLoading,
    bool isRefreshing,
  });
}

/// @nodoc
class _$HomeStateCopyWithImpl<$Res, $Val extends HomeState>
    implements $HomeStateCopyWith<$Res> {
  _$HomeStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of HomeState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? feedList = null,
    Object? lastDocument = freezed,
    Object? currentPage = null,
    Object? isLastPage = null,
    Object? isLoading = null,
    Object? isRefreshing = null,
  }) {
    return _then(
      _value.copyWith(
            feedList: null == feedList
                ? _value.feedList
                : feedList // ignore: cast_nullable_to_non_nullable
                      as List<FeedModel>,
            lastDocument: freezed == lastDocument
                ? _value.lastDocument
                : lastDocument // ignore: cast_nullable_to_non_nullable
                      as DocumentSnapshot<Object?>?,
            currentPage: null == currentPage
                ? _value.currentPage
                : currentPage // ignore: cast_nullable_to_non_nullable
                      as int,
            isLastPage: null == isLastPage
                ? _value.isLastPage
                : isLastPage // ignore: cast_nullable_to_non_nullable
                      as bool,
            isLoading: null == isLoading
                ? _value.isLoading
                : isLoading // ignore: cast_nullable_to_non_nullable
                      as bool,
            isRefreshing: null == isRefreshing
                ? _value.isRefreshing
                : isRefreshing // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$HomeStateImplCopyWith<$Res>
    implements $HomeStateCopyWith<$Res> {
  factory _$$HomeStateImplCopyWith(
    _$HomeStateImpl value,
    $Res Function(_$HomeStateImpl) then,
  ) = __$$HomeStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    List<FeedModel> feedList,
    DocumentSnapshot<Object?>? lastDocument,
    int currentPage,
    bool isLastPage,
    bool isLoading,
    bool isRefreshing,
  });
}

/// @nodoc
class __$$HomeStateImplCopyWithImpl<$Res>
    extends _$HomeStateCopyWithImpl<$Res, _$HomeStateImpl>
    implements _$$HomeStateImplCopyWith<$Res> {
  __$$HomeStateImplCopyWithImpl(
    _$HomeStateImpl _value,
    $Res Function(_$HomeStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of HomeState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? feedList = null,
    Object? lastDocument = freezed,
    Object? currentPage = null,
    Object? isLastPage = null,
    Object? isLoading = null,
    Object? isRefreshing = null,
  }) {
    return _then(
      _$HomeStateImpl(
        feedList: null == feedList
            ? _value._feedList
            : feedList // ignore: cast_nullable_to_non_nullable
                  as List<FeedModel>,
        lastDocument: freezed == lastDocument
            ? _value.lastDocument
            : lastDocument // ignore: cast_nullable_to_non_nullable
                  as DocumentSnapshot<Object?>?,
        currentPage: null == currentPage
            ? _value.currentPage
            : currentPage // ignore: cast_nullable_to_non_nullable
                  as int,
        isLastPage: null == isLastPage
            ? _value.isLastPage
            : isLastPage // ignore: cast_nullable_to_non_nullable
                  as bool,
        isLoading: null == isLoading
            ? _value.isLoading
            : isLoading // ignore: cast_nullable_to_non_nullable
                  as bool,
        isRefreshing: null == isRefreshing
            ? _value.isRefreshing
            : isRefreshing // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc

class _$HomeStateImpl implements _HomeState {
  const _$HomeStateImpl({
    required final List<FeedModel> feedList,
    required this.lastDocument,
    required this.currentPage,
    required this.isLastPage,
    required this.isLoading,
    required this.isRefreshing,
  }) : _feedList = feedList;

  final List<FeedModel> _feedList;
  @override
  List<FeedModel> get feedList {
    if (_feedList is EqualUnmodifiableListView) return _feedList;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_feedList);
  }

  @override
  final DocumentSnapshot<Object?>? lastDocument;
  @override
  final int currentPage;
  @override
  final bool isLastPage;
  @override
  final bool isLoading;
  @override
  final bool isRefreshing;

  @override
  String toString() {
    return 'HomeState(feedList: $feedList, lastDocument: $lastDocument, currentPage: $currentPage, isLastPage: $isLastPage, isLoading: $isLoading, isRefreshing: $isRefreshing)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HomeStateImpl &&
            const DeepCollectionEquality().equals(other._feedList, _feedList) &&
            (identical(other.lastDocument, lastDocument) ||
                other.lastDocument == lastDocument) &&
            (identical(other.currentPage, currentPage) ||
                other.currentPage == currentPage) &&
            (identical(other.isLastPage, isLastPage) ||
                other.isLastPage == isLastPage) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.isRefreshing, isRefreshing) ||
                other.isRefreshing == isRefreshing));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(_feedList),
    lastDocument,
    currentPage,
    isLastPage,
    isLoading,
    isRefreshing,
  );

  /// Create a copy of HomeState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$HomeStateImplCopyWith<_$HomeStateImpl> get copyWith =>
      __$$HomeStateImplCopyWithImpl<_$HomeStateImpl>(this, _$identity);
}

abstract class _HomeState implements HomeState {
  const factory _HomeState({
    required final List<FeedModel> feedList,
    required final DocumentSnapshot<Object?>? lastDocument,
    required final int currentPage,
    required final bool isLastPage,
    required final bool isLoading,
    required final bool isRefreshing,
  }) = _$HomeStateImpl;

  @override
  List<FeedModel> get feedList;
  @override
  DocumentSnapshot<Object?>? get lastDocument;
  @override
  int get currentPage;
  @override
  bool get isLastPage;
  @override
  bool get isLoading;
  @override
  bool get isRefreshing;

  /// Create a copy of HomeState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$HomeStateImplCopyWith<_$HomeStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
