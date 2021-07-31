// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'injected_container.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InjectedContainer _$InjectedContainerFromJson(Map<String, dynamic> json) {
  return InjectedContainer(
    bottomRightCorner: Point.bottomRightFromJson(
        json['bottomRightCorner'] as Map<String, dynamic>),
    topLeftCorner:
        Point.topLeftFromJson(json['topLeftCorner'] as Map<String, dynamic>),
    name: json['name'] as String,
    UUID: json['UUID'] as String,
    prototypeNode:
        PrototypeNode.prototypeNodeFromJson(json['prototypeNode'] as String),
    size: PBIntermediateNode.sizeFromJson(json['size'] as Map<String, dynamic>),
    type: json['type'] as String,
  )
    ..subsemantic = json['subsemantic'] as String
    ..children = (json['children'] as List)
        ?.map((e) => e == null
            ? null
            : PBIntermediateNode.fromJson(e as Map<String, dynamic>))
        ?.toList()
    ..child = json['child'] == null
        ? null
        : PBIntermediateNode.fromJson(json['child'] as Map<String, dynamic>)
    ..auxiliaryData = json['style'] == null
        ? null
        : IntermediateAuxiliaryData.fromJson(
            json['style'] as Map<String, dynamic>);
}

Map<String, dynamic> _$InjectedContainerToJson(InjectedContainer instance) =>
    <String, dynamic>{
      'subsemantic': instance.subsemantic,
      'children': instance.children,
      'child': instance.child,
      'style': instance.auxiliaryData,
      'name': instance.name,
      'prototypeNode': instance.prototypeNode,
      'topLeftCorner': instance.topLeftCorner,
      'bottomRightCorner': instance.bottomRightCorner,
      'type': instance.type,
      'UUID': instance.UUID,
      'size': instance.size,
    };
