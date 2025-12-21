// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'feed_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

FeedDto _$FeedDtoFromJson(Map<String, dynamic> json) {
  return _FeedDto.fromJson(json);
}

/// @nodoc
mixin _$FeedDto {
  @JsonKey(ignore: true)
  String? get id => throw _privateConstructorUsedError; // Firestore 필드 X, doc.id로만 사용
  @JsonKey(name: 'writer_id')
  String get writerId => throw _privateConstructorUsedError;
  String get nickname => throw _privateConstructorUsedError;
  List<String> get tag => throw _privateConstructorUsedError;
  String get content => throw _privateConstructorUsedError;
  @JsonKey(name: 'image_url')
  String get imageUrl => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'modified_at')
  DateTime get modifiedAt => throw _privateConstructorUsedError;

  /// Serializes this FeedDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of FeedDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FeedDtoCopyWith<FeedDto> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FeedDtoCopyWith<$Res> {
  factory $FeedDtoCopyWith(FeedDto value, $Res Function(FeedDto) then) =
      _$FeedDtoCopyWithImpl<$Res, FeedDto>;
  @useResult
  $Res call({
    @JsonKey(ignore: true) String? id,
    @JsonKey(name: 'writer_id') String writerId,
    String nickname,
    List<String> tag,
    String content,
    @JsonKey(name: 'image_url') String imageUrl,
    @JsonKey(name: 'created_at') DateTime createdAt,
    @JsonKey(name: 'modified_at') DateTime modifiedAt,
  });
}

/// @nodoc
class _$FeedDtoCopyWithImpl<$Res, $Val extends FeedDto>
    implements $FeedDtoCopyWith<$Res> {
  _$FeedDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FeedDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? writerId = null,
    Object? nickname = null,
    Object? tag = null,
    Object? content = null,
    Object? imageUrl = null,
    Object? createdAt = null,
    Object? modifiedAt = null,
  }) {
    return _then(
      _value.copyWith(
            id: freezed == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String?,
            writerId: null == writerId
                ? _value.writerId
                : writerId // ignore: cast_nullable_to_non_nullable
                      as String,
            nickname: null == nickname
                ? _value.nickname
                : nickname // ignore: cast_nullable_to_non_nullable
                      as String,
            tag: null == tag
                ? _value.tag
                : tag // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            content: null == content
                ? _value.content
                : content // ignore: cast_nullable_to_non_nullable
                      as String,
            imageUrl: null == imageUrl
                ? _value.imageUrl
                : imageUrl // ignore: cast_nullable_to_non_nullable
                      as String,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            modifiedAt: null == modifiedAt
                ? _value.modifiedAt
                : modifiedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$FeedDtoImplCopyWith<$Res> implements $FeedDtoCopyWith<$Res> {
  factory _$$FeedDtoImplCopyWith(
    _$FeedDtoImpl value,
    $Res Function(_$FeedDtoImpl) then,
  ) = __$$FeedDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(ignore: true) String? id,
    @JsonKey(name: 'writer_id') String writerId,
    String nickname,
    List<String> tag,
    String content,
    @JsonKey(name: 'image_url') String imageUrl,
    @JsonKey(name: 'created_at') DateTime createdAt,
    @JsonKey(name: 'modified_at') DateTime modifiedAt,
  });
}

/// @nodoc
class __$$FeedDtoImplCopyWithImpl<$Res>
    extends _$FeedDtoCopyWithImpl<$Res, _$FeedDtoImpl>
    implements _$$FeedDtoImplCopyWith<$Res> {
  __$$FeedDtoImplCopyWithImpl(
    _$FeedDtoImpl _value,
    $Res Function(_$FeedDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of FeedDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? writerId = null,
    Object? nickname = null,
    Object? tag = null,
    Object? content = null,
    Object? imageUrl = null,
    Object? createdAt = null,
    Object? modifiedAt = null,
  }) {
    return _then(
      _$FeedDtoImpl(
        id: freezed == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String?,
        writerId: null == writerId
            ? _value.writerId
            : writerId // ignore: cast_nullable_to_non_nullable
                  as String,
        nickname: null == nickname
            ? _value.nickname
            : nickname // ignore: cast_nullable_to_non_nullable
                  as String,
        tag: null == tag
            ? _value._tag
            : tag // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        content: null == content
            ? _value.content
            : content // ignore: cast_nullable_to_non_nullable
                  as String,
        imageUrl: null == imageUrl
            ? _value.imageUrl
            : imageUrl // ignore: cast_nullable_to_non_nullable
                  as String,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        modifiedAt: null == modifiedAt
            ? _value.modifiedAt
            : modifiedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$FeedDtoImpl implements _FeedDto {
  const _$FeedDtoImpl({
    @JsonKey(ignore: true) this.id,
    @JsonKey(name: 'writer_id') required this.writerId,
    required this.nickname,
    required final List<String> tag,
    required this.content,
    @JsonKey(name: 'image_url') required this.imageUrl,
    @JsonKey(name: 'created_at') required this.createdAt,
    @JsonKey(name: 'modified_at') required this.modifiedAt,
  }) : _tag = tag;

  factory _$FeedDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$FeedDtoImplFromJson(json);

  @override
  @JsonKey(ignore: true)
  final String? id;
  // Firestore 필드 X, doc.id로만 사용
  @override
  @JsonKey(name: 'writer_id')
  final String writerId;
  @override
  final String nickname;
  final List<String> _tag;
  @override
  List<String> get tag {
    if (_tag is EqualUnmodifiableListView) return _tag;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_tag);
  }

  @override
  final String content;
  @override
  @JsonKey(name: 'image_url')
  final String imageUrl;
  @override
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @override
  @JsonKey(name: 'modified_at')
  final DateTime modifiedAt;

  @override
  String toString() {
    return 'FeedDto(id: $id, writerId: $writerId, nickname: $nickname, tag: $tag, content: $content, imageUrl: $imageUrl, createdAt: $createdAt, modifiedAt: $modifiedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FeedDtoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.writerId, writerId) ||
                other.writerId == writerId) &&
            (identical(other.nickname, nickname) ||
                other.nickname == nickname) &&
            const DeepCollectionEquality().equals(other._tag, _tag) &&
            (identical(other.content, content) || other.content == content) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.modifiedAt, modifiedAt) ||
                other.modifiedAt == modifiedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    writerId,
    nickname,
    const DeepCollectionEquality().hash(_tag),
    content,
    imageUrl,
    createdAt,
    modifiedAt,
  );

  /// Create a copy of FeedDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FeedDtoImplCopyWith<_$FeedDtoImpl> get copyWith =>
      __$$FeedDtoImplCopyWithImpl<_$FeedDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FeedDtoImplToJson(this);
  }
}

abstract class _FeedDto implements FeedDto {
  const factory _FeedDto({
    @JsonKey(ignore: true) final String? id,
    @JsonKey(name: 'writer_id') required final String writerId,
    required final String nickname,
    required final List<String> tag,
    required final String content,
    @JsonKey(name: 'image_url') required final String imageUrl,
    @JsonKey(name: 'created_at') required final DateTime createdAt,
    @JsonKey(name: 'modified_at') required final DateTime modifiedAt,
  }) = _$FeedDtoImpl;

  factory _FeedDto.fromJson(Map<String, dynamic> json) = _$FeedDtoImpl.fromJson;

  @override
  @JsonKey(ignore: true)
  String? get id; // Firestore 필드 X, doc.id로만 사용
  @override
  @JsonKey(name: 'writer_id')
  String get writerId;
  @override
  String get nickname;
  @override
  List<String> get tag;
  @override
  String get content;
  @override
  @JsonKey(name: 'image_url')
  String get imageUrl;
  @override
  @JsonKey(name: 'created_at')
  DateTime get createdAt;
  @override
  @JsonKey(name: 'modified_at')
  DateTime get modifiedAt;

  /// Create a copy of FeedDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FeedDtoImplCopyWith<_$FeedDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
