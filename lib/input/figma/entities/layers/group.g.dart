// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'group.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Group _$GroupFromJson(Map<String, dynamic> json) {
  return Group(
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
    children: (json['children'] as List)
        ?.map((e) =>
            e == null ? null : FigmaNode.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    UUID: json['id'] as String,
    backgroundColor: json['backgroundColor'] == null
        ? null
        : FigmaColor.fromJson(json['backgroundColor'] as Map<String, dynamic>),
    prototypeNodeUUID: json['transitionNodeUUID'] as String,
    transitionDuration: json['transitionDuration'] as num,
    transitionEasing: json['transitionEasing'] as String,
  )
    ..isHome = json['isHome'] as bool
    ..fillsList = json['fills'] as List
    ..isFlowHome = json['isFlowHome']
    ..imageReference = json['imageReference'] as String
    ..pbdfType = json['pbdfType'] as String;
}

Map<String, dynamic> _$GroupToJson(Group instance) => <String, dynamic>{
      'id': instance.UUID,
      'name': instance.name,
      'pluginData': instance.pluginData,
      'sharedPluginData': instance.sharedPluginData,
      'visible': instance.isVisible,
      'transitionNodeUUID': instance.prototypeNodeUUID,
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
      'isHome': instance.isHome,
      'fills': instance.fillsList,
      'isFlowHome': instance.isFlowHome,
      'type': instance.type,
      'imageReference': instance.imageReference,
      'pbdfType': instance.pbdfType,
    };
