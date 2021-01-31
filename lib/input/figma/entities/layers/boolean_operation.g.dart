// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'boolean_operation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BooleanOperation _$BooleanOperationFromJson(Map<String, dynamic> json) {
  return BooleanOperation(
    children: (json['children'] as List)
        ?.map((e) =>
            e == null ? null : FigmaNode.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    booleanOperation: json['booleanOperation'],
    type: json['type'],
    style: json['style'] == null
        ? null
        : FigmaStyle.fromJson(json['style'] as Map<String, dynamic>),
    boundaryRectangle: json['absoluteBoundingBox'] == null
        ? null
        : Frame.fromJson(json['absoluteBoundingBox'] as Map<String, dynamic>),
    UUID: json['id'] as String,
  )
    ..name = json['name'] as String
    ..pluginData = json['pluginData']
    ..sharedPluginData = json['sharedPluginData']
    ..isVisible = json['visible'] as bool ?? true
    ..layoutAlign = json['layoutAlign'] as String
    ..constraints = json['constraints']
    ..prototypeNodeUUID = json['transitionNodeID'] as String
    ..size = json['size']
    ..strokes = json['strokes']
    ..strokeWeight = (json['strokeWeight'] as num)?.toDouble()
    ..strokeAlign = json['strokeAlign'] as String
    ..styles = json['styles']
    ..fillsList = json['fills'] as List
    ..imageReference = json['imageReference'] as String
    ..pbdfType = json['pbdfType'] as String;
}

Map<String, dynamic> _$BooleanOperationToJson(BooleanOperation instance) =>
    <String, dynamic>{
      'id': instance.UUID,
      'name': instance.name,
      'pluginData': instance.pluginData,
      'sharedPluginData': instance.sharedPluginData,
      'visible': instance.isVisible,
      'style': instance.style,
      'layoutAlign': instance.layoutAlign,
      'constraints': instance.constraints,
      'transitionNodeID': instance.prototypeNodeUUID,
      'size': instance.size,
      'strokes': instance.strokes,
      'strokeWeight': instance.strokeWeight,
      'strokeAlign': instance.strokeAlign,
      'styles': instance.styles,
      'fills': instance.fillsList,
      'children': instance.children,
      'booleanOperation': instance.booleanOperation,
      'type': instance.type,
      'absoluteBoundingBox': instance.boundaryRectangle,
      'imageReference': instance.imageReference,
      'pbdfType': instance.pbdfType,
    };
