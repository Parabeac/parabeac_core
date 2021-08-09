import 'dart:math';
import 'package:parabeac_core/generation/generators/visual-widgets/pb_text_gen.dart';
import 'package:parabeac_core/generation/prototyping/pb_prototype_node.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/inherited_container.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/interfaces/pb_inherited_intermediate.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_visual_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/align_strategy.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/child_strategy.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_context.dart';

import 'package:parabeac_core/interpret_and_optimize/helpers/abstract_intermediate_node_factory.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_color.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_context.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:parabeac_core/interpret_and_optimize/state_management/intermediate_auxillary_data.dart';

part 'inherited_text.g.dart';

@JsonSerializable()
class InheritedText extends PBVisualIntermediateNode
    implements PBInheritedIntermediate, IntermediateNodeFactory {
  ///For the generator to strip out the quotation marks.
  @JsonKey(defaultValue: false)
  bool isTextParameter = false;

  @override
  ChildrenStrategy childrenStrategy = NoChildStrategy();

  @override
  @JsonKey(
      fromJson: PrototypeNode.prototypeNodeFromJson, name: 'prototypeNodeUUID')
  PrototypeNode prototypeNode;

  @JsonKey(ignore: true)
  num alignmenttype;

  @override
  @JsonKey()
  String type = 'text';

  @override
  @JsonKey(ignore: true)
  Point topLeftCorner;
  @override
  @JsonKey(ignore: true)
  Point bottomRightCorner;

  @override
  String UUID;

  @override
  @JsonKey(fromJson: PBIntermediateNode.sizeFromJson, name: 'boundaryRectangle')
  Map size;

  @override
  @JsonKey(ignore: true)
  PBContext currentContext;

  @JsonKey(name: 'content')
  String text;
  @JsonKey(ignore: true)
  num fontSize;
  @JsonKey(ignore: true)
  String fontName;
  @JsonKey(ignore: true)
  String fontWeight; // one of the w100-w900 weights
  @JsonKey(ignore: true)
  String fontStyle; // normal, or italic
  @JsonKey(ignore: true)
  String textAlignment;
  @JsonKey(ignore: true)
  num letterSpacing;

  @override
  @JsonKey(ignore: true)
  Map<String, dynamic> originalRef;

  InheritedText({
    this.originalRef,
    name,
    this.currentContext,
    this.topLeftCorner,
    this.bottomRightCorner,
    this.UUID,
    this.size,
    this.alignmenttype,
    this.fontName,
    this.fontSize,
    this.fontStyle,
    this.fontWeight,
    this.isTextParameter,
    this.letterSpacing,
    this.prototypeNode,
    this.text,
    this.textAlignment,
  }) : super(topLeftCorner, bottomRightCorner, currentContext, name,
            UUID: UUID ?? '') {
    generator = PBTextGen();
    if (text?.contains('\$') ?? false) {
      text = _sanitizeText(text);
    }
  }

  String _sanitizeText(String text) {
    return text.replaceAll('\$', '\\\$');
  }

  static PBIntermediateNode fromJson(Map<String, dynamic> json) =>
      _$InheritedTextFromJson(json)
        ..topLeftCorner = Point.topLeftFromJson(json)
        ..bottomRightCorner = Point.bottomRightFromJson(json)
        ..originalRef = json
        ..fontSize = InheritedTextPBDLHelper.fontSizeFromJson(json)
        ..fontName = InheritedTextPBDLHelper.fontNameFromJson(json)
        ..fontWeight = InheritedTextPBDLHelper.fontWeightFromJson(json)
        ..fontStyle = InheritedTextPBDLHelper.fontStyleFromJson(json)
        ..textAlignment = InheritedTextPBDLHelper.textAlignmentFromJson(json)
        ..letterSpacing = InheritedTextPBDLHelper.letterSpacingFromJson(json)
        ..auxiliaryData.color = PBColor.fromJson(json['style']['textStyle']['fontColor']);

  @override
  PBIntermediateNode createIntermediateNode(Map<String, dynamic> json) {
    var inheritedText = InheritedText.fromJson(json);
    // Return an [InheritedContainer] that wraps this text
    return InheritedContainer(
      UUID: inheritedText.UUID,
      topLeftCorner: inheritedText.topLeftCorner,
      bottomRightCorner: inheritedText.bottomRightCorner,
      name: inheritedText.name,
      currentContext: inheritedText.currentContext,
      size: inheritedText.size,
      originalRef: json,
    )..addChild(inheritedText);
  }
}

class InheritedTextPBDLHelper {
  static num fontSizeFromJson(Map<String, dynamic> json) =>
      _fontDescriptor(json)['fontSize'];

  static String fontNameFromJson(Map<String, dynamic> json) =>
      _fontDescriptor(json)['fontName'];

  static String fontWeightFromJson(Map<String, dynamic> json) =>
      _fontDescriptor(json)['fontWeight'];

  static String fontStyleFromJson(Map<String, dynamic> json) =>
      _fontDescriptor(json)['fontStyle'];

  static String textAlignmentFromJson(Map<String, dynamic> json) {
    var alignmenttype = _textStyle(json)['paragraphStyle']['alignment'] ?? 0;
    switch (alignmenttype) {
      case 1:
        return 'right';
      case 2:
        return 'center';
      case 3:
        return 'justify';
      default:
        return 'left';
    }
  }

  static num letterSpacingFromJson(Map<String, dynamic> json) =>
      _fontDescriptor(json)['letterSpacing'];

  static Map<String, dynamic> _fontDescriptor(Map<String, dynamic> json) =>
      _textStyle(json)['fontDescriptor'];

  static Map<String, dynamic> _textStyle(Map<String, dynamic> json) =>
      json['style']['textStyle'];
}
