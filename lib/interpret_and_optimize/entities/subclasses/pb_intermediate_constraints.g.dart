// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pb_intermediate_constraints.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PBIntermediateConstraints _$PBIntermediateConstraintsFromJson(
    Map<String, dynamic> json) {
  return PBIntermediateConstraints(
    pinLeft: json['pinLeft'] as bool,
    pinRight: json['pinRight'] as bool,
    pinTop: json['pinTop'] as bool,
    pinBottom: json['pinBottom'] as bool,
    fixedHeight: json['fixedHeight'] as bool,
    fixedWidth: json['fixedWidth'] as bool,
  );
}

Map<String, dynamic> _$PBIntermediateConstraintsToJson(
        PBIntermediateConstraints instance) =>
    <String, dynamic>{
      'pinLeft': instance.pinLeft,
      'pinRight': instance.pinRight,
      'pinTop': instance.pinTop,
      'pinBottom': instance.pinBottom,
      'fixedHeight': instance.fixedHeight,
      'fixedWidth': instance.fixedWidth,
    };
