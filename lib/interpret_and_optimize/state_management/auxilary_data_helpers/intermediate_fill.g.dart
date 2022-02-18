// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'intermediate_fill.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PBFill _$PBFillFromJson(Map<String, dynamic> json) {
  return PBFill(
    opacity: json['opacity'] as num ?? 100,
    blendMode: json['blendMode'] as String,
    type: json['type'] as String,
    isEnabled: json['isEnabled'] as bool ?? true,
    color: json['color'] == null
        ? null
        : PBColor.fromJson(json['color'] as Map<String, dynamic>),
    imageRef: json['imageRef'] as String,
  )
    ..gradientStops = (json['gradientStops'] as List)
        ?.map((e) => e == null
            ? null
            : PBGradientStop.fromJson(e as Map<String, dynamic>))
        ?.toList()
    ..gradientHandlePositions =
        PBFill._pointsFromJson(json['gradientHandlePositions'] as List);
}

Map<String, dynamic> _$PBFillToJson(PBFill instance) => <String, dynamic>{
      'gradientStops':
          instance.gradientStops?.map((e) => e?.toJson())?.toList(),
      'gradientHandlePositions':
          PBFill._pointsToJson(instance.gradientHandlePositions),
      'imageRef': instance.imageRef,
      'color': instance.color?.toJson(),
      'opacity': instance.opacity,
      'blendMode': instance.blendMode,
      'type': instance.type,
      'isEnabled': instance.isEnabled,
    };

PBGradientStop _$PBGradientStopFromJson(Map<String, dynamic> json) {
  return PBGradientStop(
    color: json['color'] == null
        ? null
        : PBColor.fromJson(json['color'] as Map<String, dynamic>),
    position: json['position'] as num,
  );
}

Map<String, dynamic> _$PBGradientStopToJson(PBGradientStop instance) =>
    <String, dynamic>{
      'color': instance.color,
      'position': instance.position,
    };
