// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inherited_scaffold.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InheritedScaffold _$InheritedScaffoldFromJson(Map<String, dynamic> json) {
  return InheritedScaffold(
    SketchNode.fromJson(json['originalRef'] as Map<String, dynamic>),
    topLeftCorner:
        Point.fromJson(json['topLeftCorner'] as Map<String, dynamic>),
    bottomRightCorner:
        Point.fromJson(json['bottomRightCorner'] as Map<String, dynamic>),
    name: json['name'] as String,
  )
    ..subsemantic = json['subsemantic'] as String
    ..widgetType = json['widgetType'] as String
    ..size = json['size'] as Map<String, dynamic>
    ..borderInfo = json['borderInfo'] as Map<String, dynamic>
    ..alignment = json['alignment'] as Map<String, dynamic>
    ..child = json['child']
    ..color = json['color'] as String
    ..navbar = json['navbar']
    ..tabbar = json['tabbar']
    ..backgroundColor = json['backgroundColor'] as String
    ..UUID = json['UUID'] as String
    ..body = json['body']
    ..semanticName = json['semanticName'] as String;
}

Map<String, dynamic> _$InheritedScaffoldToJson(InheritedScaffold instance) =>
    <String, dynamic>{
      'subsemantic': instance.subsemantic,
      'widgetType': instance.widgetType,
      'topLeftCorner': instance.topLeftCorner,
      'bottomRightCorner': instance.bottomRightCorner,
      'size': instance.size,
      'borderInfo': instance.borderInfo,
      'alignment': instance.alignment,
      'child': instance.child,
      'color': instance.color,
      'originalRef': instance.originalRef,
      'name': instance.name,
      'navbar': instance.navbar,
      'tabbar': instance.tabbar,
      'backgroundColor': instance.backgroundColor,
      'UUID': instance.UUID,
      'body': instance.body,
      'semanticName': instance.semanticName,
    };
