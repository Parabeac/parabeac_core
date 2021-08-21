// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'injected_container.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InjectedContainer _$InjectedContainerFromJson(Map<String, dynamic> json) {
  return InjectedContainer(
    json['UUID'],
    Rectangle3D.fromJson(json['boundaryRectangle'] as Map<String, dynamic>),
    name: json['name'] as String,
    prototypeNode:
        PrototypeNode.prototypeNodeFromJson(json['prototypeNode'] as String),
    type: json['type'] as String,
  )
    ..subsemantic = json['subsemantic'] as String
    ..constraints = json['constraints'] == null
        ? null
        : PBIntermediateConstraints.fromJson(
            json['constraints'] as Map<String, dynamic>)
    ..auxiliaryData = json['style'] == null
        ? null
        : IntermediateAuxiliaryData.fromJson(
            json['style'] as Map<String, dynamic>);
}

Map<String, dynamic> _$InjectedContainerToJson(InjectedContainer instance) =>
    <String, dynamic>{
      'subsemantic': instance.subsemantic,
      'UUID': instance.UUID,
      'constraints': instance.constraints,
      'boundaryRectangle': Rectangle3D.toJson(instance.frame),
      'style': instance.auxiliaryData,
      'name': instance.name,
      'prototypeNode': instance.prototypeNode,
      'type': instance.type,
    };
