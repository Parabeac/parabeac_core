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
  );
}

Map<String, dynamic> _$PBFillToJson(PBFill instance) => <String, dynamic>{
      'imageRef': instance.imageRef,
      'color': instance.color?.toJson(),
      'opacity': instance.opacity,
      'blendMode': instance.blendMode,
      'type': instance.type,
      'isEnabled': instance.isEnabled,
    };
