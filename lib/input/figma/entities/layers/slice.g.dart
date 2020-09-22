// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'slice.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FigmaSlice _$FigmaSliceFromJson(Map<String, dynamic> json) {
  return FigmaSlice(
    name: json['name'] as String,
    visible: json['visible'] as bool,
    type: json['type'] as String,
    pluginData: json['pluginData'],
    sharedPluginData: json['sharedPluginData'],
    layoutAlign: json['layoutAlign'] as String,
    constraints: json['constraints'],
    boundaryRectangle: json['absoluteBoundingBox'] == null
        ? null
        : Frame.fromJson(json['absoluteBoundingBox'] as Map<String, dynamic>),
    size: json['size'],
  )
    ..UUID = json['id'] as String
    ..prototypeNodeUUID = json['transitionNodeID'] as String
    ..isVisible = json['isVisible'] as bool
    ..style = json['style'];
}

Map<String, dynamic> _$FigmaSliceToJson(FigmaSlice instance) =>
    <String, dynamic>{
      'name': instance.name,
      'visible': instance.visible,
      'pluginData': instance.pluginData,
      'sharedPluginData': instance.sharedPluginData,
      'type': instance.type,
      'id': instance.UUID,
      'layoutAlign': instance.layoutAlign,
      'constraints': instance.constraints,
      'transitionNodeID': instance.prototypeNodeUUID,
      'absoluteBoundingBox': instance.boundaryRectangle,
      'size': instance.size,
      'isVisible': instance.isVisible,
      'style': instance.style,
    };
