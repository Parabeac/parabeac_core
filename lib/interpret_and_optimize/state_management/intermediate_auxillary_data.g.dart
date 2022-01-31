// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'intermediate_auxillary_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

IntermediateAuxiliaryData _$IntermediateAuxiliaryDataFromJson(
    Map<String, dynamic> json) {
  return IntermediateAuxiliaryData(
    colors: (json['fills'] as List)
        ?.map((e) =>
            e == null ? null : PBFill.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    borderInfo: json['borderOptions'] == null
        ? null
        : PBBorderInfo.fromJson(json['borderOptions'] as Map<String, dynamic>),
    effects: (json['effects'] as List)
        ?.map((e) =>
            e == null ? null : PBEffect.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    intermediateTextStyle: json['intermediateTextStyle'] == null
        ? null
        : PBTextStyle.fromJson(
            json['intermediateTextStyle'] as Map<String, dynamic>),
  )..alignment = json['alignment'] as Map<String, dynamic>;
}

Map<String, dynamic> _$IntermediateAuxiliaryDataToJson(
        IntermediateAuxiliaryData instance) =>
    <String, dynamic>{
      'alignment': instance.alignment,
      'fills': instance.colors?.map((e) => e?.toJson())?.toList(),
      'borderOptions': instance.borderInfo?.toJson(),
      'effects': instance.effects?.map((e) => e?.toJson())?.toList(),
      'intermediateTextStyle': instance.intermediateTextStyle?.toJson(),
    };
