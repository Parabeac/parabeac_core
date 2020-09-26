// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'canvas.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Canvas _$CanvasFromJson(Map<String, dynamic> json) {
  return Canvas(
    name: json['name'] as String,
    type: json['type'] as String,
    children: (json['children'] as List)
        ?.map((e) =>
            e == null ? null : FigmaNode.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    backgroundColor: json['backgroundColor'],
    prototypeStartNodeID: json['prototypeStartNodeID'],
    prototypeDevice: json['prototypeDevice'],
    exportSettings: json['exportSettings'],
  )
    ..UUID = json['id'] as String
    ..pluginData = json['pluginData']
    ..sharedPluginData = json['sharedPluginData']
    ..boundaryRectangle = json['boundaryRectangle']
    ..isVisible = json['visible'] as bool ?? true
    ..prototypeNodeUUID = json['prototypeNodeUUID'] as String
    ..style = json['style'];
}

Map<String, dynamic> _$CanvasToJson(Canvas instance) => <String, dynamic>{
      'id': instance.UUID,
      'pluginData': instance.pluginData,
      'sharedPluginData': instance.sharedPluginData,
      'type': instance.type,
      'name': instance.name,
      'children': instance.children,
      'backgroundColor': instance.backgroundColor,
      'prototypeStartNodeID': instance.prototypeStartNodeID,
      'prototypeDevice': instance.prototypeDevice,
      'exportSettings': instance.exportSettings,
      'boundaryRectangle': instance.boundaryRectangle,
      'visible': instance.isVisible,
      'prototypeNodeUUID': instance.prototypeNodeUUID,
      'style': instance.style,
    };
