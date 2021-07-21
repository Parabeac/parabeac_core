import 'package:parabeac_core/design_logic/color.dart';
import 'package:parabeac_core/design_logic/design_node.dart';
import 'package:parabeac_core/design_logic/text.dart';
import 'package:parabeac_core/generation/generators/visual-widgets/pb_text_gen.dart';
import 'package:parabeac_core/generation/prototyping/pb_prototype_node.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/interfaces/pb_inherited_intermediate.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_visual_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/child_strategy.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_context.dart';
import 'package:parabeac_core/interpret_and_optimize/value_objects/point.dart';

class InheritedText extends PBVisualIntermediateNode
    with PBColorMixin
    implements PBInheritedIntermediate {
  ///For the generator to strip out the quotation marks.
  bool isTextParameter = false;

  @override
  ChildrenStrategy childrenStrategy = NoChildStrategy();

  @override
  var originalRef;

  @override
  PrototypeNode prototypeNode;

  num alignmenttype;

  String text;
  num fontSize;
  String fontName;
  String fontWeight; // one of the w100-w900 weights
  String fontStyle; // normal, or italic
  String textAlignment;
  num letterSpacing;

  InheritedText(this.originalRef, String name, {PBContext currentContext})
      : super(
            Point(originalRef.boundaryRectangle.x,
                originalRef.boundaryRectangle.y),
            Point(
                originalRef.boundaryRectangle.x +
                    originalRef.boundaryRectangle.width,
                originalRef.boundaryRectangle.y +
                    originalRef.boundaryRectangle.height),
            currentContext,
            name,
            UUID: originalRef.UUID ?? '') {
    if (originalRef is DesignNode && originalRef.prototypeNodeUUID != null) {
      prototypeNode = PrototypeNode(originalRef?.prototypeNodeUUID);
    }
    generator = PBTextGen();

    text = (originalRef as Text).content;
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
  void alignChild() {
    // Text don't have children.
  }
}
