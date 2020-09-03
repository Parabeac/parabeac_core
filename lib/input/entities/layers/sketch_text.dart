import 'package:parabeac_core/design_logic/design_node.dart';
import 'package:parabeac_core/design_logic/text.dart';
import 'package:parabeac_core/input/entities/abstract_sketch_node_factory.dart';
import 'package:parabeac_core/input/entities/layers/abstract_layer.dart';
import 'package:parabeac_core/input/entities/objects/frame.dart';
import 'package:parabeac_core/input/entities/style/style.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/inherited_text.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_context.dart';
import '../../../interpret_and_optimize/entities/inherited_container.dart';
import '../../../interpret_and_optimize/entities/inherited_text.dart';
import '../../../interpret_and_optimize/value_objects/point.dart';

part 'sketch_text.g.dart';

// title: Text Layer
// description: A text layer represents a discrete block or line of text
@JsonSerializable(nullable: false)
class SketchText extends SketchNode implements SketchNodeFactory, Text {
  @override
  @JsonKey(name: '_class')
  String CLASS_NAME = 'text';
  final dynamic attributedString;
  final bool automaticallyDrawOnUnderlyingPath;
  final bool dontSynchroniseWithSymbol;
  final dynamic lineSpacingBehaviour;
  final dynamic textBehaviour;
  final dynamic glyphBounds;

  @override
  @JsonKey(name: 'frame')
  var boundaryRectangle;

  SketchText(
      {String do_objectID,
      booleanOperation,
      exportOptions,
      Frame this.boundaryRectangle,
      flow,
      bool isFixedToViewport,
      bool isFlippedHorizontal,
      bool isFlippedVertical,
      bool isLocked,
      bool isVisible,
      layerListExpandedType,
      String name,
      bool nameIsFixed,
      resizingConstraint,
      resizingType,
      int rotation,
      sharedStyleID,
      bool shouldBreakMaskChain,
      bool hasClippingMask,
      int clippingMaskMode,
      userInfo,
      Style style,
      bool maintainScrollPosition,
      this.attributedString,
      this.automaticallyDrawOnUnderlyingPath,
      this.dontSynchroniseWithSymbol,
      this.lineSpacingBehaviour,
      this.textBehaviour,
      this.glyphBounds})
      : super(
            do_objectID,
            booleanOperation,
            exportOptions,
            boundaryRectangle,
            flow,
            isFixedToViewport,
            isFlippedHorizontal,
            isFlippedVertical,
            isLocked,
            isVisible,
            layerListExpandedType,
            name,
            nameIsFixed,
            resizingConstraint,
            resizingType,
            rotation,
            sharedStyleID,
            shouldBreakMaskChain,
            hasClippingMask,
            clippingMaskMode,
            userInfo,
            style,
            maintainScrollPosition);

  @override
  SketchNode createSketchNode(Map<String, dynamic> json) =>
      SketchText.fromJson(json);
  factory SketchText.fromJson(Map<String, dynamic> json) =>
      _$SketchTextFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$SketchTextToJson(this);

  @override
  Future<PBIntermediateNode> interpretNode(PBContext currentContext) =>
      Future.value(InheritedContainer(
        this,
        Point(boundaryRectangle.x, boundaryRectangle.y),
        Point(boundaryRectangle.x + boundaryRectangle.width,
            boundaryRectangle.y + boundaryRectangle.height),
        currentContext: currentContext,
      )..addChild(
          InheritedText(this, currentContext: currentContext),
        ));

  @override
  String content;
}
