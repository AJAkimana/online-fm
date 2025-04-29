// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'radio_station.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RadioStation _$RadioStationFromJson(Map<String, dynamic> json) => RadioStation(
      frequency: json['frequency'] as String,
      name: json['name'] as String,
      isFavorite: json['isFavorite'] as bool,
    );

Map<String, dynamic> _$RadioStationToJson(RadioStation instance) =>
    <String, dynamic>{
      'frequency': instance.frequency,
      'name': instance.name,
      'isFavorite': instance.isFavorite,
    };
