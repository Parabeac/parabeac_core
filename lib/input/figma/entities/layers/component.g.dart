// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'component.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Component _$ComponentFromJson(Map<String, dynamic> json) {
  return Component(
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
    overrideProperties: (json['overrideProperties'] as List)
        ?.map((e) => e == null
            ? null
            : OverridableProperty.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    children: (json['children'] as List)
        ?.map((e) =>
            e == null ? null : FigmaNode.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    backgroundColor: json['backgroundColor'] == null
        ? null
        : FigmaColor.fromJson(json['backgroundColor'] as Map<String, dynamic>),
    symbolID: json['symbolID'] as String,
    overriadableProperties: json['overriadableProperties'] as List,
  )
    ..UUID = json['id'] as String
    ..prototypeNodeUUID = json['transitionNodeID'] as String
    ..fillsList = json['fills'] as List
    ..imageReference = json['imageReference'] as String;
}

Map<String, dynamic> _$ComponentToJson(Component instance) => <String, dynamic>{
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
      'fills': instance.fillsList,
      'imageReference': instance.imageReference,
      'type': instance.type,
      'overrideProperties': instance.overrideProperties,
      'overriadableProperties': instance.overriadableProperties,
      'symbolID': instance.symbolID,
    };
