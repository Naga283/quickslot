// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'venue.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$VenueImpl _$$VenueImplFromJson(Map<String, dynamic> json) => _$VenueImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      sportType: json['sportType'] as String,
      address: json['address'] as String,
      imageUrl: json['imageUrl'] as String?,
    );

Map<String, dynamic> _$$VenueImplToJson(_$VenueImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'sportType': instance.sportType,
      'address': instance.address,
      'imageUrl': instance.imageUrl,
    };
