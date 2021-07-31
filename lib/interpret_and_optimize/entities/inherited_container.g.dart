// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inherited_container.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InheritedContainer _$InheritedContainerFromJson(Map<String, dynamic> json) {
  return InheritedContainer(
    name: json['name'] as String,
    isBackgroundVisible: json['isBackgroundVisible'] as bool ?? true,
    UUID: json['UUID'] as String,
    size: PBIntermediateNode.sizeFromJson(
        json['boundaryRectangle'] as Map<String, dynamic>),
    prototypeNode: PrototypeNode.prototypeNodeFromJson(
        json['prototypeNodeUUID'] as String),
  )
    ..subsemantic = json['subsemantic'] as String
    ..child = json['child'] == null
        ? null
        : PBIntermediateNode.fromJson(json['child'] as Map<String, dynamic>)
    ..auxiliaryData = json['style'] == null
        ? null
        : IntermediateAuxiliaryData.fromJson(
            json['style'] as Map<String, dynamic>)
    ..type = json['type'] as String;
}

Map<String, dynamic> _$InheritedContainerToJson(InheritedContainer instance) =>
    <String, dynamic>{
      'subsemantic': instance.subsemantic,
      'child': instance.child,
      'style': instance.auxiliaryData,
      'name': instance.name,
      'prototypeNodeUUID': instance.prototypeNode,
      'isBackgroundVisible': instance.isBackgroundVisible,
      'type': instance.type,
      'UUID': instance.UUID,
      'boundaryRectangle': instance.size,
    };
