// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'waitlist.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$WaitlistImpl _$$WaitlistImplFromJson(Map<String, dynamic> json) =>
    _$WaitlistImpl(
      id: json['id'] as String,
      userId: json['userId'] as String,
      slotId: json['slotId'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      slot: json['slot'] == null
          ? null
          : Slot.fromJson(json['slot'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$WaitlistImplToJson(_$WaitlistImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'slotId': instance.slotId,
      'createdAt': instance.createdAt.toIso8601String(),
      'slot': instance.slot,
    };
