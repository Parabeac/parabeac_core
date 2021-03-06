// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'instance.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Instance _$InstanceFromJson(Map<String, dynamic> json) {
  return Instance(
    name: json['name'],
    isVisible: json['visible'] ?? true,
    type: json['type'],
    pluginData: json['pluginData'],
    sharedPluginData: json['sharedPluginData'],
    boundaryRectangle: json['absoluteBoundingBox'] == null
        ? null
        : Frame.fromJson(json['absoluteBoundingBox'] as Map<String, dynamic>),
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
    children: (json['children'] as List)
        ?.map((e) =>
            e == null ? null : FigmaNode.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    parameters: json['parameters'] as List,
    symbolID: json['symbolID'] as String,
    backgroundColor: json['backgroundColor'] == null
        ? null
        : FigmaColor.fromJson(json['backgroundColor'] as Map<String, dynamic>),
    prototypeNodeUUID: json['transitionNodeUUID'] as String,
    transitionDuration: json['transitionDuration'] as num,
    transitionEasing: json['transitionEasing'] as String,
  )
    ..UUID = json['id'] as String
    ..isHome = json['isHome'] as bool
    ..fillsList = json['fills'] as List
    ..imageReference = json['imageReference'] as String
    ..isFlowHome = json['isFlowHome']
    ..pbdfType = json['pbdfType'] as String;
}

Map<String, dynamic> _$InstanceToJson(Instance instance) => <String, dynamic>{
      'id': instance.UUID,
      'name': instance.name,
      'pluginData': instance.pluginData,
      'sharedPluginData': instance.sharedPluginData,
      'visible': instance.isVisible,
      'transitionNodeUUID': instance.prototypeNodeUUID,
      'transitionDuration': instance.transitionDuration,
      'transitionEasing': instance.transitionEasing,
      'absoluteBoundingBox': instance.boundaryRectangle,
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
      'isHome': instance.isHome,
      'fills': instance.fillsList,
      'imageReference': instance.imageReference,
      'isFlowHome': instance.isFlowHome,
      'type': instance.type,
      'parameters': instance.parameters,
      'symbolID': instance.symbolID,
      'children': instance.children,
      'componentId': instance.componentId,
      'pbdfType': instance.pbdfType,
    };
