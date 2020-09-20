// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'frame.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FigmaFrame _$FigmaFrameFromJson(Map<String, dynamic> json) {
  return FigmaFrame(
    id: json['id'] as String,
    name: json['name'] as String,
    visible: json['visible'] as bool,
    type: json['type'] as String,
    pluginData: json['pluginData'],
    sharedPluginData: json['sharedPluginData'],
    boundaryRectangle: json['absoluteBoundingBox'] == null
        ? null
        : Frame.fromJson(json['absoluteBoundingBox'] as Map<String, dynamic>),
    style: json['style'],
    fills: json['fills'],
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
  )
    ..UUID = json['UUID'] as String
    ..isVisible = json['isVisible'] as bool
    ..prototypeNodeUUID = json['transitionNodeID'] as String
    ..children = (json['children'] as List)
        ?.map((e) =>
            e == null ? null : FigmaNode.fromJson(e as Map<String, dynamic>))
        ?.toList();
}

Map<String, dynamic> _$FigmaFrameToJson(FigmaFrame instance) =>
    <String, dynamic>{
      'pluginData': instance.pluginData,
      'sharedPluginData': instance.sharedPluginData,
      'UUID': instance.UUID,
      'absoluteBoundingBox': instance.boundaryRectangle,
      'isVisible': instance.isVisible,
      'transitionNodeID': instance.prototypeNodeUUID,
      'style': instance.style,
      'children': instance.children,
      'fills': instance.fills,
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
      'id': instance.id,
      'name': instance.name,
      'visible': instance.visible,
      'type': instance.type,
    };
