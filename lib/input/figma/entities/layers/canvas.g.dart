// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'canvas.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Canvas _$CanvasFromJson(Map<String, dynamic> json) {
  return Canvas(
    id: json['id'] as String,
    name: json['name'] as String,
    type: json['type'] as String,
    children: json['children'],
    backgroundColor: json['backgroundColor'],
    prototypeStartNodeID: json['prototypeStartNodeID'],
    prototypeDevice: json['prototypeDevice'],
    exportSettings: json['exportSettings'],
  )
    ..visible = json['visible'] as bool
    ..pluginData = json['pluginData']
    ..sharedPluginData = json['sharedPluginData']
    ..UUID = json['UUID'] as String
    ..boundaryRectangle = json['boundaryRectangle']
    ..isVisible = json['isVisible'] as bool
    ..prototypeNodeUUID = json['prototypeNodeUUID'] as String
    ..style = json['style'];
}

Map<String, dynamic> _$CanvasToJson(Canvas instance) => <String, dynamic>{
      'visible': instance.visible,
      'pluginData': instance.pluginData,
      'sharedPluginData': instance.sharedPluginData,
      'id': instance.id,
      'name': instance.name,
      'type': instance.type,
      'children': instance.children,
      'backgroundColor': instance.backgroundColor,
      'prototypeStartNodeID': instance.prototypeStartNodeID,
      'prototypeDevice': instance.prototypeDevice,
      'exportSettings': instance.exportSettings,
      'UUID': instance.UUID,
      'boundaryRectangle': instance.boundaryRectangle,
      'isVisible': instance.isVisible,
      'prototypeNodeUUID': instance.prototypeNodeUUID,
      'style': instance.style,
    };
