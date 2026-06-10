// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'waitlist.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Waitlist _$WaitlistFromJson(Map<String, dynamic> json) {
  return _Waitlist.fromJson(json);
}

/// @nodoc
mixin _$Waitlist {
  String get id => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  String get slotId => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  Slot? get slot => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $WaitlistCopyWith<Waitlist> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WaitlistCopyWith<$Res> {
  factory $WaitlistCopyWith(Waitlist value, $Res Function(Waitlist) then) =
      _$WaitlistCopyWithImpl<$Res, Waitlist>;
  @useResult
  $Res call(
      {String id,
      String userId,
      String slotId,
      DateTime createdAt,
      Slot? slot});

  $SlotCopyWith<$Res>? get slot;
}

/// @nodoc
class _$WaitlistCopyWithImpl<$Res, $Val extends Waitlist>
    implements $WaitlistCopyWith<$Res> {
  _$WaitlistCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? slotId = null,
    Object? createdAt = null,
    Object? slot = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      slotId: null == slotId
          ? _value.slotId
          : slotId // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      slot: freezed == slot
          ? _value.slot
          : slot // ignore: cast_nullable_to_non_nullable
              as Slot?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $SlotCopyWith<$Res>? get slot {
    if (_value.slot == null) {
      return null;
    }

    return $SlotCopyWith<$Res>(_value.slot!, (value) {
      return _then(_value.copyWith(slot: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$WaitlistImplCopyWith<$Res>
    implements $WaitlistCopyWith<$Res> {
  factory _$$WaitlistImplCopyWith(
          _$WaitlistImpl value, $Res Function(_$WaitlistImpl) then) =
      __$$WaitlistImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String userId,
      String slotId,
      DateTime createdAt,
      Slot? slot});

  @override
  $SlotCopyWith<$Res>? get slot;
}

/// @nodoc
class __$$WaitlistImplCopyWithImpl<$Res>
    extends _$WaitlistCopyWithImpl<$Res, _$WaitlistImpl>
    implements _$$WaitlistImplCopyWith<$Res> {
  __$$WaitlistImplCopyWithImpl(
      _$WaitlistImpl _value, $Res Function(_$WaitlistImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? slotId = null,
    Object? createdAt = null,
    Object? slot = freezed,
  }) {
    return _then(_$WaitlistImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      slotId: null == slotId
          ? _value.slotId
          : slotId // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      slot: freezed == slot
          ? _value.slot
          : slot // ignore: cast_nullable_to_non_nullable
              as Slot?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$WaitlistImpl implements _Waitlist {
  const _$WaitlistImpl(
      {required this.id,
      required this.userId,
      required this.slotId,
      required this.createdAt,
      this.slot});

  factory _$WaitlistImpl.fromJson(Map<String, dynamic> json) =>
      _$$WaitlistImplFromJson(json);

  @override
  final String id;
  @override
  final String userId;
  @override
  final String slotId;
  @override
  final DateTime createdAt;
  @override
  final Slot? slot;

  @override
  String toString() {
    return 'Waitlist(id: $id, userId: $userId, slotId: $slotId, createdAt: $createdAt, slot: $slot)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WaitlistImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.slotId, slotId) || other.slotId == slotId) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.slot, slot) || other.slot == slot));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, userId, slotId, createdAt, slot);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$WaitlistImplCopyWith<_$WaitlistImpl> get copyWith =>
      __$$WaitlistImplCopyWithImpl<_$WaitlistImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$WaitlistImplToJson(
      this,
    );
  }
}

abstract class _Waitlist implements Waitlist {
  const factory _Waitlist(
      {required final String id,
      required final String userId,
      required final String slotId,
      required final DateTime createdAt,
      final Slot? slot}) = _$WaitlistImpl;

  factory _Waitlist.fromJson(Map<String, dynamic> json) =
      _$WaitlistImpl.fromJson;

  @override
  String get id;
  @override
  String get userId;
  @override
  String get slotId;
  @override
  DateTime get createdAt;
  @override
  Slot? get slot;
  @override
  @JsonKey(ignore: true)
  _$$WaitlistImplCopyWith<_$WaitlistImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
