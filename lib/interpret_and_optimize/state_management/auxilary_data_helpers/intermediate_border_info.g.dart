// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'intermediate_border_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

IntermediateBorderInfo _$IntermediateBorderInfoFromJson(
    Map<String, dynamic> json) {
  return IntermediateBorderInfo(
    border: IntermediateBorderInfo._borderFromJson(json['borders'] as List),
    thickness: json['strokeWeight'] as num,
    strokeAlign: json['strokeAlign'] as String,
    strokeJoin: json['strokeJoin'] as String,
    strokeDashes: json['strokeDashes'] as List,
    borderRadius: json['cornerRadius'] as num,
  );
}

Map<String, dynamic> _$IntermediateBorderInfoToJson(
        IntermediateBorderInfo instance) =>
    <String, dynamic>{
      'borders': instance.border?.toJson(),
      'strokeWeight': instance.thickness,
      'strokeAlign': instance.strokeAlign,
      'strokeJoin': instance.strokeJoin,
      'strokeDashes': instance.strokeDashes,
      'cornerRadius': instance.borderRadius,
    };
