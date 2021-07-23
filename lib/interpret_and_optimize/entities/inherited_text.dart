import 'package:parabeac_core/design_logic/color.dart';
import 'package:parabeac_core/design_logic/design_node.dart';
import 'package:parabeac_core/design_logic/text.dart';
import 'package:parabeac_core/generation/generators/visual-widgets/pb_text_gen.dart';
import 'package:parabeac_core/generation/prototyping/pb_prototype_node.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/interfaces/pb_inherited_intermediate.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_visual_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/abstract_intermediate_node_factory.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_context.dart';
import 'package:parabeac_core/interpret_and_optimize/value_objects/point.dart';
import 'package:json_annotation/json_annotation.dart';

part 'inherited_text.g.dart';

@JsonSerializable()
class InheritedText extends PBVisualIntermediateNode
    with PBColorMixin
    implements PBInheritedIntermediate, IntermediateNodeFactory {
  ///For the generator to strip out the quotation marks.
  bool isTextParameter = false;

  @override
  @JsonKey(fromJson: PrototypeNode.prototypeNodeFromJson)
  PrototypeNode prototypeNode;

  @JsonKey(ignore: true)
  num alignmenttype;

  @override
  @JsonKey()
  String type = 'inherited_text';

  @override
  @JsonKey(fromJson: Point.topLeftFromJson)
  Point topLeftCorner;
  @override
  @JsonKey(fromJson: Point.bottomRightFromJson)
  Point bottomRightCorner;

  @override
  String UUID;

  @override
  var size;

  @JsonKey(name: 'content')
  String text;
  @JsonKey(fromJson: InheritedTextPBDLHelper.fontSizeFromJson)
  num fontSize;
  @JsonKey(fromJson: InheritedTextPBDLHelper.fontNameFromJson)
  String fontName;
  @JsonKey(fromJson: InheritedTextPBDLHelper.fontWeightFromJson)
  String fontWeight; // one of the w100-w900 weights
  @JsonKey(fromJson: InheritedTextPBDLHelper.fontStyleFromJson)
  String fontStyle; // normal, or italic
  @JsonKey(fromJson: InheritedTextPBDLHelper.textAlignmentFromJson)
  String textAlignment;
  @JsonKey(fromJson: InheritedTextPBDLHelper.letterSpacingFromJson)
  num letterSpacing;

  InheritedText({
    name,
    PBContext currentContext,
    this.topLeftCorner,
    this.bottomRightCorner,
    this.UUID,
    this.type,
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
    // if (originalRef is DesignNode && originalRef.prototypeNodeUUID != null) {
    //   prototypeNode = PrototypeNode(originalRef?.prototypeNodeUUID);
    // }
    generator = PBTextGen();

    // text = (originalRef as Text).content;
    if (text.contains('\$')) {
      text = _sanitizeText(text);
    }
    fontSize = originalRef.style.textStyle.fontDescriptor.fontSize;
    auxiliaryData.color = toHex(originalRef.style.textStyle.fontColor);
    fontName = originalRef.style.textStyle.fontDescriptor.fontName;
    fontWeight = originalRef.style.textStyle.fontDescriptor.fontWeight;
    fontStyle = originalRef.style.textStyle.fontDescriptor.fontStyle;
    letterSpacing = originalRef.style.textStyle.fontDescriptor.letterSpacing;

    alignmenttype = originalRef.style.textStyle.paragraphStyle.alignment;
    if (alignmenttype == 0) {
      textAlignment = 'left';
    } else if (alignmenttype == 1) {
      textAlignment = 'right';
    } else if (alignmenttype == 2) {
      textAlignment = 'center';
    } else if (alignmenttype == 3) {
      textAlignment = 'justify';
    }
  }

  String _sanitizeText(String text) {
    return text.replaceAll('\$', '\\\$');
  }

  @override
  void addChild(PBIntermediateNode node) {
    assert(true, 'Adding a child to InheritedText should not be possible.');
    return;
  }

  @override
  void alignChild() {
    // Text don't have children.
  }

  @override
  PBIntermediateNode fromJson(Map<String, dynamic> json) =>
      _$InheritedTextFromJson(json);
}

class InheritedTextPBDLHelper {
  static num fontSizeFromJson(Map<String, dynamic> json) =>
      _fontDescriptor(json)['fontDescriptor']['fontSize'];

  static String fontNameFromJson(Map<String, dynamic> json) =>
      _fontDescriptor(json)['fontDescriptor']['fontName'];

  static String fontWeightFromJson(Map<String, dynamic> json) =>
      _fontDescriptor(json)['fontWeight'];

  static String fontStyleFromJson(Map<String, dynamic> json) =>
      _fontDescriptor(json)['fontStyle'];

  static num textAlignmentFromJson(Map<String, dynamic> json) =>
      _textStyle(json)['paragraphStyle']['alignment'] ?? 0;

  static num letterSpacingFromJson(Map<String, dynamic> json) =>
      _fontDescriptor(json)['letterSpacing'];

  static Map<String, dynamic> _fontDescriptor(Map<String, dynamic> json) =>
      _textStyle(json)['fontDescriptor'];

  static Map<String, dynamic> _textStyle(Map<String, dynamic> json) =>
      json['style']['textStyle'];
}
