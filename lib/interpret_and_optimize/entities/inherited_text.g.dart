// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inherited_text.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InheritedText _$InheritedTextFromJson(Map<String, dynamic> json) {
  return InheritedText(
    name: json['name'],
    UUID: json['UUID'] as String,
    size: PBIntermediateNode.sizeFromJson(
        json['boundaryRectangle'] as Map<String, dynamic>),
    fontName: InheritedTextPBDLHelper.fontNameFromJson(
        json['fontName'] as Map<String, dynamic>),
    fontSize: InheritedTextPBDLHelper.fontSizeFromJson(
        json['fontSize'] as Map<String, dynamic>),
    fontStyle: InheritedTextPBDLHelper.fontStyleFromJson(
        json['fontStyle'] as Map<String, dynamic>),
    fontWeight: InheritedTextPBDLHelper.fontWeightFromJson(
        json['fontWeight'] as Map<String, dynamic>),
    isTextParameter: json['isTextParameter'] as bool,
    letterSpacing: InheritedTextPBDLHelper.letterSpacingFromJson(
        json['letterSpacing'] as Map<String, dynamic>),
    prototypeNode: PrototypeNode.prototypeNodeFromJson(
        json['prototypeNodeUUID'] as String),
    text: json['content'] as String,
    textAlignment: InheritedTextPBDLHelper.textAlignmentFromJson(
        json['textAlignment'] as Map<String, dynamic>),
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

Map<String, dynamic> _$InheritedTextToJson(InheritedText instance) =>
    <String, dynamic>{
      'subsemantic': instance.subsemantic,
      'children': instance.children,
      'child': instance.child,
      'name': instance.name,
      'isTextParameter': instance.isTextParameter,
      'prototypeNodeUUID': instance.prototypeNode,
      'type': instance.type,
      'UUID': instance.UUID,
      'boundaryRectangle': instance.size,
      'content': instance.text,
      'fontSize': instance.fontSize,
      'fontName': instance.fontName,
      'fontWeight': instance.fontWeight,
      'fontStyle': instance.fontStyle,
      'textAlignment': instance.textAlignment,
      'letterSpacing': instance.letterSpacing,
    };
