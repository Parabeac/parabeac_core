// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inherited_scaffold.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InheritedScaffold _$InheritedScaffoldFromJson(Map<String, dynamic> json) {
  return InheritedScaffold(
    topLeftCorner:
        Point.topLeftFromJson(json['topLeftCorner'] as Map<String, dynamic>),
    bottomRightCorner: Point.bottomRightFromJson(
        json['bottomRightCorner'] as Map<String, dynamic>),
    name: json['name'] as String,
    isHomeScreen: json['isHomeScreen'] as bool ?? false,
    UUID: json['UUID'] as String,
    prototypeNode: PrototypeNode.prototypeNodeFromJson(
        json['prototypeNode'] as Map<String, dynamic>),
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
        : PBIntermediateNode.fromJson(json['child'] as Map<String, dynamic>);
}

Map<String, dynamic> _$InheritedScaffoldToJson(InheritedScaffold instance) =>
    <String, dynamic>{
      'subsemantic': instance.subsemantic,
      'children': instance.children,
      'name': instance.name,
      'prototypeNode': instance.prototypeNode,
      'isHomeScreen': instance.isHomeScreen,
      'topLeftCorner': instance.topLeftCorner,
      'bottomRightCorner': instance.bottomRightCorner,
      'type': instance.type,
      'UUID': instance.UUID,
      'size': instance.size,
      'child': instance.child,
    };
