// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'canvas.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Canvas _$CanvasFromJson(Map<String, dynamic> json) {
  return Canvas()
    ..id = json['id'] as String
    ..name = json['name'] as String
    ..type = json['type'] as String
    ..children = json['children']
    ..backgroundColor = json['backgroundColor']
    ..prototypeStartNodeID = json['prototypeStartNodeID']
    ..prototypeDevice = json['prototypeDevice']
    ..exportSettings = json['exportSettings'];
}

Map<String, dynamic> _$CanvasToJson(Canvas instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'type': instance.type,
      'children': instance.children,
      'backgroundColor': instance.backgroundColor,
      'prototypeStartNodeID': instance.prototypeStartNodeID,
      'prototypeDevice': instance.prototypeDevice,
      'exportSettings': instance.exportSettings,
    };
