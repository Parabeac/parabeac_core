// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'figma_border.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FigmaBorder _$FigmaBorderFromJson(Map<String, dynamic> json) {
  return FigmaBorder(
    isEnabled: json['isEnabled'] as bool,
    fillType: (json['fillType'] as num)?.toDouble(),
    color: json['color'] == null
        ? null
        : FigmaColor.fromJson(json['color'] as Map<String, dynamic>),
    thickness: (json['thickness'] as num)?.toDouble(),
  );
}

Map<String, dynamic> _$FigmaBorderToJson(FigmaBorder instance) =>
    <String, dynamic>{
      'isEnabled': instance.isEnabled,
      'fillType': instance.fillType,
      'color': instance.color,
      'thickness': instance.thickness,
    };
