// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'intermediate_effect.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PBEffect _$PBEffectFromJson(Map<String, dynamic> json) {
  return PBEffect(
    type: json['type'] as String,
    visible: json['visible'] as bool,
    radius: json['radius'] as num,
    color: json['color'] == null
        ? null
        : PBColor.fromJson(json['color'] as Map<String, dynamic>),
    blendMode: json['blendMode'] as String,
    offset: json['offset'] as Map<String, dynamic>,
    showShadowBehindNode: json['showShadowBehindNode'] as bool,
  )..pbdlType = json['pbdlType'] as String;
}

Map<String, dynamic> _$PBEffectToJson(PBEffect instance) => <String, dynamic>{
      'type': instance.type,
      'visible': instance.visible,
      'radius': instance.radius,
      'color': instance.color?.toJson(),
      'blendMode': instance.blendMode,
      'offset': instance.offset,
      'showShadowBehindNode': instance.showShadowBehindNode,
      'pbdlType': instance.pbdlType,
    };
