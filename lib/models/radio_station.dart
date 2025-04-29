import 'package:json_annotation/json_annotation.dart';

part 'radio_station.g.dart';

@JsonSerializable()
class RadioStation {
  final String frequency;
  final String name;
  final bool isFavorite;

  RadioStation({
    required this.frequency,
    required this.name,
    required this.isFavorite
  });

  factory RadioStation.fromJson(Map<String, dynamic> json) => _$RadioStationFromJson(json);

  Map<String, dynamic> toJson() => _$RadioStationToJson(this);
}
