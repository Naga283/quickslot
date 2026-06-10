// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'booking.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BookingImpl _$$BookingImplFromJson(Map<String, dynamic> json) =>
    _$BookingImpl(
      id: json['id'] as String,
      userId: json['userId'] as String,
      slotId: json['slotId'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      slot: json['slot'] == null
          ? null
          : Slot.fromJson(json['slot'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$BookingImplToJson(_$BookingImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'slotId': instance.slotId,
      'createdAt': instance.createdAt.toIso8601String(),
      'slot': instance.slot,
    };
