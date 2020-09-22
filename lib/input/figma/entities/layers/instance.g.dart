// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'instance.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Instance _$InstanceFromJson(Map<String, dynamic> json) {
  return Instance(
    name: json['name'],
    visible: json['visible'],
    type: json['type'],
    pluginData: json['pluginData'],
    sharedPluginData: json['sharedPluginData'],
    boundaryRectangle: json['absoluteBoundingBox'] == null
        ? null
        : Frame.fromJson(json['absoluteBoundingBox'] as Map<String, dynamic>),
    style: json['style'],
    fills: json['fills'],
    strokes: json['strokes'],
    strokeWeight: json['strokeWeight'],
    strokeAlign: json['strokeAlign'],
    cornerRadius: json['cornerRadius'],
    constraints: json['constraints'],
    layoutAlign: json['layoutAlign'],
    size: json['size'],
    horizontalPadding: json['horizontalPadding'],
    verticalPadding: json['verticalPadding'],
    itemSpacing: json['itemSpacing'],
    componentId: json['componentId'] as String,
  )
    ..UUID = json['UUID'] as String
    ..isVisible = json['isVisible'] as bool
    ..prototypeNodeUUID = json['transitionNodeID'] as String
    ..children = (json['children'] as List)
        ?.map((e) =>
            e == null ? null : FigmaNode.fromJson(e as Map<String, dynamic>))
        ?.toList();
}

Map<String, dynamic> _$InstanceToJson(Instance instance) => <String, dynamic>{
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
      'name': instance.name,
      'visible': instance.visible,
      'type': instance.type,
      'componentId': instance.componentId,
    };
