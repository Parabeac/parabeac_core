// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inherited_text.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InheritedText _$InheritedTextFromJson(Map<String, dynamic> json) {
  return InheritedText(
    json['UUID'] as String,
    DeserializedRectangle.fromJson(
        json['boundaryRectangle'] as Map<String, dynamic>),
    name: json['name'],
    isTextParameter: json['isTextParameter'] as bool ?? false,
    prototypeNode: PrototypeNode.prototypeNodeFromJson(
        json['prototypeNodeUUID'] as String),
    text: json['content'] as String,
  )
    ..subsemantic = json['subsemantic'] as String
    ..constraints = json['constraints'] == null
        ? null
        : PBIntermediateConstraints.fromJson(
            json['constraints'] as Map<String, dynamic>)
    ..auxiliaryData = json['style'] == null
        ? null
        : IntermediateAuxiliaryData.fromJson(
            json['style'] as Map<String, dynamic>)
    ..type = json['type'] as String;
}

Map<String, dynamic> _$InheritedTextToJson(InheritedText instance) =>
    <String, dynamic>{
      'subsemantic': instance.subsemantic,
      'UUID': instance.UUID,
      'constraints': instance.constraints,
      'boundaryRectangle': DeserializedRectangle.toJson(instance.frame),
      'style': instance.auxiliaryData,
      'name': instance.name,
      'isTextParameter': instance.isTextParameter,
      'prototypeNodeUUID': instance.prototypeNode,
      'type': instance.type,
      'content': instance.text,
    };
