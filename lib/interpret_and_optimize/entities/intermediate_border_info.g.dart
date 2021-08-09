// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'intermediate_border_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

IntermediateBorderInfo _$IntermediateBorderInfoFromJson(
    Map<String, dynamic> json) {
  return IntermediateBorderInfo(
    borderRadius: json['borderRadius'] as num,
    color: json['color'] == null
        ? null
        : PBColor.fromJson(json['color'] as Map<String, dynamic>),
    thickness: json['thickness'] as num,
    shape: json['shape'] as String,
    isBorderOutlineVisible: json['isEnabled'] as bool,
  );
}

Map<String, dynamic> _$IntermediateBorderInfoToJson(
        IntermediateBorderInfo instance) =>
    <String, dynamic>{
      'borderRadius': instance.borderRadius,
      'color': instance.color,
      'thickness': instance.thickness,
      'shape': instance.shape,
      'isEnabled': instance.isBorderOutlineVisible,
    };
