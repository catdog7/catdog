// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'pet_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

PetDto _$PetDtoFromJson(Map<String, dynamic> json) {
  return _PetDto.fromJson(json);
}

/// @nodoc
mixin _$PetDto {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'user_id')
  String get userId => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get species => throw _privateConstructorUsedError;
  @JsonKey(name: 'birth_date')
  DateTime? get birthDate => throw _privateConstructorUsedError;
  @JsonKey(name: 'birth_date_precision')
  String get birthDatePrecision => throw _privateConstructorUsedError;
  @JsonKey(name: 'image_2d_url')
  String? get image2dUrl => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime? get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this PetDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PetDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PetDtoCopyWith<PetDto> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PetDtoCopyWith<$Res> {
  factory $PetDtoCopyWith(PetDto value, $Res Function(PetDto) then) =
      _$PetDtoCopyWithImpl<$Res, PetDto>;
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'user_id') String userId,
    String name,
    String species,
    @JsonKey(name: 'birth_date') DateTime? birthDate,
    @JsonKey(name: 'birth_date_precision') String birthDatePrecision,
    @JsonKey(name: 'image_2d_url') String? image2dUrl,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
  });
}

/// @nodoc
class _$PetDtoCopyWithImpl<$Res, $Val extends PetDto>
    implements $PetDtoCopyWith<$Res> {
  _$PetDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PetDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? name = null,
    Object? species = null,
    Object? birthDate = freezed,
    Object? birthDatePrecision = null,
    Object? image2dUrl = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            userId: null == userId
                ? _value.userId
                : userId // ignore: cast_nullable_to_non_nullable
                      as String,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            species: null == species
                ? _value.species
                : species // ignore: cast_nullable_to_non_nullable
                      as String,
            birthDate: freezed == birthDate
                ? _value.birthDate
                : birthDate // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            birthDatePrecision: null == birthDatePrecision
                ? _value.birthDatePrecision
                : birthDatePrecision // ignore: cast_nullable_to_non_nullable
                      as String,
            image2dUrl: freezed == image2dUrl
                ? _value.image2dUrl
                : image2dUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
            createdAt: freezed == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            updatedAt: freezed == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PetDtoImplCopyWith<$Res> implements $PetDtoCopyWith<$Res> {
  factory _$$PetDtoImplCopyWith(
    _$PetDtoImpl value,
    $Res Function(_$PetDtoImpl) then,
  ) = __$$PetDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'user_id') String userId,
    String name,
    String species,
    @JsonKey(name: 'birth_date') DateTime? birthDate,
    @JsonKey(name: 'birth_date_precision') String birthDatePrecision,
    @JsonKey(name: 'image_2d_url') String? image2dUrl,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
  });
}

/// @nodoc
class __$$PetDtoImplCopyWithImpl<$Res>
    extends _$PetDtoCopyWithImpl<$Res, _$PetDtoImpl>
    implements _$$PetDtoImplCopyWith<$Res> {
  __$$PetDtoImplCopyWithImpl(
    _$PetDtoImpl _value,
    $Res Function(_$PetDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PetDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? name = null,
    Object? species = null,
    Object? birthDate = freezed,
    Object? birthDatePrecision = null,
    Object? image2dUrl = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(
      _$PetDtoImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        userId: null == userId
            ? _value.userId
            : userId // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        species: null == species
            ? _value.species
            : species // ignore: cast_nullable_to_non_nullable
                  as String,
        birthDate: freezed == birthDate
            ? _value.birthDate
            : birthDate // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        birthDatePrecision: null == birthDatePrecision
            ? _value.birthDatePrecision
            : birthDatePrecision // ignore: cast_nullable_to_non_nullable
                  as String,
        image2dUrl: freezed == image2dUrl
            ? _value.image2dUrl
            : image2dUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
        createdAt: freezed == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        updatedAt: freezed == updatedAt
            ? _value.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PetDtoImpl implements _PetDto {
  const _$PetDtoImpl({
    required this.id,
    @JsonKey(name: 'user_id') required this.userId,
    required this.name,
    required this.species,
    @JsonKey(name: 'birth_date') this.birthDate,
    @JsonKey(name: 'birth_date_precision') required this.birthDatePrecision,
    @JsonKey(name: 'image_2d_url') this.image2dUrl,
    @JsonKey(name: 'created_at') this.createdAt,
    @JsonKey(name: 'updated_at') this.updatedAt,
  });

  factory _$PetDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$PetDtoImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'user_id')
  final String userId;
  @override
  final String name;
  @override
  final String species;
  @override
  @JsonKey(name: 'birth_date')
  final DateTime? birthDate;
  @override
  @JsonKey(name: 'birth_date_precision')
  final String birthDatePrecision;
  @override
  @JsonKey(name: 'image_2d_url')
  final String? image2dUrl;
  @override
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;
  @override
  @JsonKey(name: 'updated_at')
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'PetDto(id: $id, userId: $userId, name: $name, species: $species, birthDate: $birthDate, birthDatePrecision: $birthDatePrecision, image2dUrl: $image2dUrl, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PetDtoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.species, species) || other.species == species) &&
            (identical(other.birthDate, birthDate) ||
                other.birthDate == birthDate) &&
            (identical(other.birthDatePrecision, birthDatePrecision) ||
                other.birthDatePrecision == birthDatePrecision) &&
            (identical(other.image2dUrl, image2dUrl) ||
                other.image2dUrl == image2dUrl) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    userId,
    name,
    species,
    birthDate,
    birthDatePrecision,
    image2dUrl,
    createdAt,
    updatedAt,
  );

  /// Create a copy of PetDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PetDtoImplCopyWith<_$PetDtoImpl> get copyWith =>
      __$$PetDtoImplCopyWithImpl<_$PetDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PetDtoImplToJson(this);
  }
}

abstract class _PetDto implements PetDto {
  const factory _PetDto({
    required final String id,
    @JsonKey(name: 'user_id') required final String userId,
    required final String name,
    required final String species,
    @JsonKey(name: 'birth_date') final DateTime? birthDate,
    @JsonKey(name: 'birth_date_precision')
    required final String birthDatePrecision,
    @JsonKey(name: 'image_2d_url') final String? image2dUrl,
    @JsonKey(name: 'created_at') final DateTime? createdAt,
    @JsonKey(name: 'updated_at') final DateTime? updatedAt,
  }) = _$PetDtoImpl;

  factory _PetDto.fromJson(Map<String, dynamic> json) = _$PetDtoImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'user_id')
  String get userId;
  @override
  String get name;
  @override
  String get species;
  @override
  @JsonKey(name: 'birth_date')
  DateTime? get birthDate;
  @override
  @JsonKey(name: 'birth_date_precision')
  String get birthDatePrecision;
  @override
  @JsonKey(name: 'image_2d_url')
  String? get image2dUrl;
  @override
  @JsonKey(name: 'created_at')
  DateTime? get createdAt;
  @override
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt;

  /// Create a copy of PetDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PetDtoImplCopyWith<_$PetDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
