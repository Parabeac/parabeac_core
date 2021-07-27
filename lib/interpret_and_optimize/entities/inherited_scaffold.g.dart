// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inherited_scaffold.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InheritedScaffold _$InheritedScaffoldFromJson(Map<String, dynamic> json) {
  return InheritedScaffold(
    name: json['name'] as String,
    isHomeScreen: json['isFlowHome'] as bool ?? false,
    UUID: json['UUID'] as String,
    prototypeNode: PrototypeNode.prototypeNodeFromJson(
        json['prototypeNodeUUID'] as Map<String, dynamic>),
    size: PBIntermediateNode.sizeFromJson(
        json['boundaryRectangle'] as Map<String, dynamic>),
  )
    ..subsemantic = json['subsemantic'] as String
    ..type = json['type'] as String;
}

Map<String, dynamic> _$InheritedScaffoldToJson(InheritedScaffold instance) =>
    <String, dynamic>{
      'subsemantic': instance.subsemantic,
      'name': instance.name,
      'prototypeNodeUUID': instance.prototypeNode,
      'isFlowHome': instance.isHomeScreen,
      'type': instance.type,
      'UUID': instance.UUID,
      'boundaryRectangle': instance.size,
    };
