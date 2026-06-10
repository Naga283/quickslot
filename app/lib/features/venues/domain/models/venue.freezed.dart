// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'venue.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Venue _$VenueFromJson(Map<String, dynamic> json) {
  return _Venue.fromJson(json);
}

/// @nodoc
mixin _$Venue {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get sportType => throw _privateConstructorUsedError;
  String get address => throw _privateConstructorUsedError;
  String? get imageUrl => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $VenueCopyWith<Venue> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $VenueCopyWith<$Res> {
  factory $VenueCopyWith(Venue value, $Res Function(Venue) then) =
      _$VenueCopyWithImpl<$Res, Venue>;
  @useResult
  $Res call(
      {String id,
      String name,
      String sportType,
      String address,
      String? imageUrl});
}

/// @nodoc
class _$VenueCopyWithImpl<$Res, $Val extends Venue>
    implements $VenueCopyWith<$Res> {
  _$VenueCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? sportType = null,
    Object? address = null,
    Object? imageUrl = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      sportType: null == sportType
          ? _value.sportType
          : sportType // ignore: cast_nullable_to_non_nullable
              as String,
      address: null == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String,
      imageUrl: freezed == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$VenueImplCopyWith<$Res> implements $VenueCopyWith<$Res> {
  factory _$$VenueImplCopyWith(
          _$VenueImpl value, $Res Function(_$VenueImpl) then) =
      __$$VenueImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      String sportType,
      String address,
      String? imageUrl});
}

/// @nodoc
class __$$VenueImplCopyWithImpl<$Res>
    extends _$VenueCopyWithImpl<$Res, _$VenueImpl>
    implements _$$VenueImplCopyWith<$Res> {
  __$$VenueImplCopyWithImpl(
      _$VenueImpl _value, $Res Function(_$VenueImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? sportType = null,
    Object? address = null,
    Object? imageUrl = freezed,
  }) {
    return _then(_$VenueImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      sportType: null == sportType
          ? _value.sportType
          : sportType // ignore: cast_nullable_to_non_nullable
              as String,
      address: null == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String,
      imageUrl: freezed == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$VenueImpl implements _Venue {
  const _$VenueImpl(
      {required this.id,
      required this.name,
      required this.sportType,
      required this.address,
      this.imageUrl});

  factory _$VenueImpl.fromJson(Map<String, dynamic> json) =>
      _$$VenueImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String sportType;
  @override
  final String address;
  @override
  final String? imageUrl;

  @override
  String toString() {
    return 'Venue(id: $id, name: $name, sportType: $sportType, address: $address, imageUrl: $imageUrl)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$VenueImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.sportType, sportType) ||
                other.sportType == sportType) &&
            (identical(other.address, address) || other.address == address) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, name, sportType, address, imageUrl);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$VenueImplCopyWith<_$VenueImpl> get copyWith =>
      __$$VenueImplCopyWithImpl<_$VenueImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$VenueImplToJson(
      this,
    );
  }
}

abstract class _Venue implements Venue {
  const factory _Venue(
      {required final String id,
      required final String name,
      required final String sportType,
      required final String address,
      final String? imageUrl}) = _$VenueImpl;

  factory _Venue.fromJson(Map<String, dynamic> json) = _$VenueImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String get sportType;
  @override
  String get address;
  @override
  String? get imageUrl;
  @override
  @JsonKey(ignore: true)
  _$$VenueImplCopyWith<_$VenueImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
