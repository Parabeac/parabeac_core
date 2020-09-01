import 'package:parabeac_core/design_logic/design_node.dart';
import 'package:parabeac_core/generation/generators/visual-widgets/pb_text_gen.dart';
import 'package:parabeac_core/input/entities/layers/abstract_layer.dart';
import 'package:parabeac_core/input/entities/layers/text.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/interfaces/pb_inherited_intermediate.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_visual_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_context.dart';
import 'package:parabeac_core/interpret_and_optimize/value_objects/point.dart';
import 'package:json_annotation/json_annotation.dart';

part 'inherited_text.g.dart';

@JsonSerializable(nullable: false)
class InheritedText extends PBVisualIntermediateNode
    implements PBInheritedIntermediate {
  ///For the generator to strip out the quotation marks.
  bool isTextParameter = false;

  @override
  String UUID;

  @override
  DesignNode originalRef;

  @JsonKey(ignore: true)
  num alignmenttype;
  @JsonKey(ignore: true)
  PBContext currentContext;

  String text;

  String widgetType = 'TEXT';

  num fontSize;

  String fontName;
  String weight;
  String textAlignment;

  InheritedText(this.originalRef, {this.currentContext})
      : super(
            Point(originalRef.boundaryRectangle.x,
                originalRef.boundaryRectangle.y),
            Point(
                originalRef.boundaryRectangle.x +
                    originalRef.boundaryRectangle.width,
                originalRef.boundaryRectangle.y +
                    originalRef.boundaryRectangle.height),
            currentContext) {
    generator = PBTextGen();

    UUID = originalRef.UUID;
    text = (originalRef as Text).attributedString['string'];
    fontSize = originalRef.style.textStyle.fontDescriptor.fontSize;
    color = originalRef.style.textStyle.color.toHex();
    fontName = originalRef.style.textStyle.fontDescriptor.fontName;
    weight = originalRef.style.textStyle.weight;
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

  @override
  void addChild(PBIntermediateNode node) {
    assert(true, 'Adding a child to InheritedText should not be possible.');
    return;
  }

  @override
  void alignChild() {
    // TODO: implement alignChild
  }

  factory InheritedText.fromJson(Map<String, Object> json) =>
      _$InheritedTextFromJson(json);
  Map<String, Object> toJson() => _$InheritedTextToJson(this);
}
