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
  )
    ..prototypeNodeUUID = json['transitionNodeID'] as String
    ..fillsList = json['fills'] as List
    ..imageReference = json['imageReference'] as String
    ..pbdfType = json['pbdfType'] as String
    ..isFlowHome = json['isFlowHome'];
}

Map<String, dynamic> _$FigmaFrameToJson(FigmaFrame instance) =>
    <String, dynamic>{
      'id': instance.UUID,
      'name': instance.name,
      'pluginData': instance.pluginData,
      'sharedPluginData': instance.sharedPluginData,
      'visible': instance.isVisible,
      'absoluteBoundingBox': instance.boundaryRectangle,
      'transitionNodeID': instance.prototypeNodeUUID,
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
      'fills': instance.fillsList,
      'imageReference': instance.imageReference,
      'pbdfType': instance.pbdfType,
      'isFlowHome': instance.isFlowHome,
    };
