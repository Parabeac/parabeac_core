// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'slice.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FigmaSlice _$FigmaSliceFromJson(Map<String, dynamic> json) {
  return FigmaSlice(
    name: json['name'] as String,
    type: json['type'] as String,
    pluginData: json['pluginData'],
    sharedPluginData: json['sharedPluginData'],
    layoutAlign: json['layoutAlign'] as String,
    constraints: json['constraints'] == null
        ? null
        : FigmaConstraints.fromJson(
            json['constraints'] as Map<String, dynamic>),
    boundaryRectangle: json['absoluteBoundingBox'] == null
        ? null
        : Frame.fromJson(json['absoluteBoundingBox'] as Map<String, dynamic>),
    size: json['size'],
    prototypeNodeUUID: json['transitionNodeID'] as String,
    transitionDuration: json['transitionDuration'] as num,
    transitionEasing: json['transitionEasing'] as String,
  )
    ..UUID = json['id'] as String
    ..isVisible = json['visible'] as bool ?? true
    ..pbdfType = json['pbdfType'] as String;
}

Map<String, dynamic> _$FigmaSliceToJson(FigmaSlice instance) =>
    <String, dynamic>{
      'id': instance.UUID,
      'name': instance.name,
      'pluginData': instance.pluginData,
      'sharedPluginData': instance.sharedPluginData,
      'transitionNodeID': instance.prototypeNodeUUID,
      'transitionDuration': instance.transitionDuration,
      'transitionEasing': instance.transitionEasing,
      'type': instance.type,
      'layoutAlign': instance.layoutAlign,
      'constraints': instance.constraints,
      'absoluteBoundingBox': instance.boundaryRectangle,
      'size': instance.size,
      'visible': instance.isVisible,
      'pbdfType': instance.pbdfType,
    };
