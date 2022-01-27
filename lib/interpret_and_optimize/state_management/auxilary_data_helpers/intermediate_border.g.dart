// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'intermediate_border.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PBBorder _$PBBorderFromJson(Map<String, dynamic> json) {
  return PBBorder(
    blendMode: json['blendMode'] as String,
    type: json['type'] as String,
    color: json['color'] == null
        ? null
        : PBColor.fromJson(json['color'] as Map<String, dynamic>),
    visible: json['visible'] as bool ?? true,
  );
}

Map<String, dynamic> _$PBBorderToJson(PBBorder instance) => <String, dynamic>{
      'blendMode': instance.blendMode,
      'type': instance.type,
      'color': instance.color?.toJson(),
      'visible': instance.visible,
    };
