// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'frame.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FigmaFrame _$FigmaFrameFromJson(Map<String, dynamic> json) {
  return FigmaFrame(
    name: json['name'],
    isVisible: json['visible'] ?? true,
    type: json['type'],
    pluginData: json['pluginData'],
    sharedPluginData: json['sharedPluginData'],
    boundaryRectangle: json['absoluteBoundingBox'] == null
        ? null
        : Frame.fromJson(json['absoluteBoundingBox'] as Map<String, dynamic>),
    strokes: json['strokes'],
    strokeWeight: (json['strokeWeight'] as num)?.toDouble(),
    strokeAlign: json['strokeAlign'] as String,
    cornerRadius: (json['cornerRadius'] as num)?.toDouble(),
    constraints: json['constraints'],
    layoutAlign: json['layoutAlign'] as String,
    size: json['size'],
    horizontalPadding: (json['horizontalPadding'] as num)?.toDouble(),
    verticalPadding: (json['verticalPadding'] as num)?.toDouble(),
    itemSpacing: (json['itemSpacing'] as num)?.toDouble(),
    children: (json['children'] as List)
        ?.map((e) =>
            e == null ? null : FigmaNode.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    UUID: json['id'] as String,
    backgroundColor: json['backgroundColor'] == null
        ? null
        : FigmaColor.fromJson(json['backgroundColor'] as Map<String, dynamic>),
    transitionDuration: json['transitionDuration'] as num,
    transitionEasing: json['transitionEasing'] as String,
    prototypeNodeUUID: json['transitionNodeID'] as String,
  )
    ..isFlowHome = json['isFlowHome'] ?? false
    ..fillsList = json['fills'] as List
    ..imageReference = json['imageReference'] as String
    ..pbdfType = json['pbdfType'] as String;
}

Map<String, dynamic> _$FigmaFrameToJson(FigmaFrame instance) =>
    <String, dynamic>{
      'id': instance.UUID,
      'name': instance.name,
      'pluginData': instance.pluginData,
      'sharedPluginData': instance.sharedPluginData,
      'visible': instance.isVisible,
      'transitionNodeID': instance.prototypeNodeUUID,
      'transitionDuration': instance.transitionDuration,
      'transitionEasing': instance.transitionEasing,
      'absoluteBoundingBox': instance.boundaryRectangle,
      'children': instance.children,
      'strokes': instance.strokes,
      'strokeWeight': instance.strokeWeight,
      'strokeAlign': instance.strokeAlign,
      'cornerRadius': instance.cornerRadius,
      'constraints': instance.constraints,
      'layoutAlign': instance.layoutAlign,
      'size': instance.size,
      'horizontalPadding': instance.horizontalPadding,
      'verticalPadding': instance.verticalPadding,
      'itemSpacing': instance.itemSpacing,
      'backgroundColor': instance.backgroundColor,
      'type': instance.type,
      'isFlowHome': instance.isFlowHome,
      'fills': instance.fillsList,
      'imageReference': instance.imageReference,
      'pbdfType': instance.pbdfType,
    };
