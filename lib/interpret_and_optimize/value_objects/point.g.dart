// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'point.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Point _$PointFromJson(Map<String, dynamic> json) {
  return Point(
    (json['x'] as num)?.toDouble(),
    (json['y'] as num)?.toDouble(),
  );
}

Map<String, dynamic> _$PointToJson(Point instance) => <String, dynamic>{
      'x': instance.x,
      'y': instance.y,
    };
