// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'intermediate_auxillary_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

IntermediateAuxiliaryData _$IntermediateAuxiliaryDataFromJson(
    Map<String, dynamic> json) {
  return IntermediateAuxiliaryData(
    alignment: json['alignment'] as Map<String, dynamic>,
    color: ColorUtils.pbColorFromJsonFills(
        json['fills'] as List<Map<String, dynamic>>),
  );
}

Map<String, dynamic> _$IntermediateAuxiliaryDataToJson(
        IntermediateAuxiliaryData instance) =>
    <String, dynamic>{
      'alignment': instance.alignment,
      'fills': instance.color?.toJson(),
    };
