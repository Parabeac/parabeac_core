// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inherited_container.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InheritedContainer _$InheritedContainerFromJson(Map<String, dynamic> json) {
  return InheritedContainer(
    name: json['name'] as String,
    isBackgroundVisible: json['isBackgroundVisible'] as bool,
    UUID: json['UUID'] as String,
    size: PBIntermediateNode.sizeFromJson(
        json['boundaryRectangle'] as Map<String, dynamic>),
    prototypeNode: PrototypeNode.prototypeNodeFromJson(
        json['prototypeNodeUUID'] as String),
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
    ..type = json['type'] as String;
}

Map<String, dynamic> _$InheritedContainerToJson(InheritedContainer instance) =>
    <String, dynamic>{
      'subsemantic': instance.subsemantic,
      'children': instance.children,
      'child': instance.child,
      'name': instance.name,
      'prototypeNodeUUID': instance.prototypeNode,
      'isBackgroundVisible': instance.isBackgroundVisible,
      'type': instance.type,
      'UUID': instance.UUID,
      'boundaryRectangle': instance.size,
    };
