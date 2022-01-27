// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'intermediate_border_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PBBorderInfo _$PBBorderInfoFromJson(Map<String, dynamic> json) {
  return PBBorderInfo(
    borders: (json['borders'] as List)
        ?.map((e) =>
            e == null ? null : PBBorder.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    strokeWeight: json['strokeWeight'] as num,
    strokeAlign: json['strokeAlign'] as String,
    strokeJoin: json['strokeJoin'] as String,
    strokeDashes: json['strokeDashes'] as List,
    cornerRadius: json['cornerRadius'] as num,
  );
}

Map<String, dynamic> _$PBBorderInfoToJson(PBBorderInfo instance) =>
    <String, dynamic>{
      'borders': instance.borders?.map((e) => e?.toJson())?.toList(),
      'strokeWeight': instance.strokeWeight,
      'strokeAlign': instance.strokeAlign,
      'strokeJoin': instance.strokeJoin,
      'strokeDashes': instance.strokeDashes,
      'cornerRadius': instance.cornerRadius,
    };
