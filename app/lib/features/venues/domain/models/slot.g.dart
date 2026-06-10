// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'slot.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SlotImpl _$$SlotImplFromJson(Map<String, dynamic> json) => _$SlotImpl(
      id: json['id'] as String,
      venueId: json['venueId'] as String,
      date: DateTime.parse(json['date'] as String),
      startTime: DateTime.parse(json['startTime'] as String),
      endTime: DateTime.parse(json['endTime'] as String),
      status: $enumDecode(_$SlotStatusEnumMap, json['status']),
    );

Map<String, dynamic> _$$SlotImplToJson(_$SlotImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'venueId': instance.venueId,
      'date': instance.date.toIso8601String(),
      'startTime': instance.startTime.toIso8601String(),
      'endTime': instance.endTime.toIso8601String(),
      'status': _$SlotStatusEnumMap[instance.status]!,
    };

const _$SlotStatusEnumMap = {
  SlotStatus.available: 'AVAILABLE',
  SlotStatus.booked: 'BOOKED',
};
