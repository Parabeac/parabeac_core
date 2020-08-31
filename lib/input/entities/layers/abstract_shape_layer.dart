// title: Abstract Shape Layer
// description: Abstract base layer for all shape layers
import 'package:parabeac_core/design_logic/design_shape.dart';
import 'package:parabeac_core/input/entities/layers/abstract_layer.dart';
import 'package:parabeac_core/input/entities/objects/frame.dart';
import 'package:parabeac_core/input/entities/style/style.dart';

abstract class AbstractShapeLayer extends SketchNode implements DesignShape {
  final bool edited;
  final bool isClosed;
  final dynamic pointRadiusBehaviour;
  final List points;

  AbstractShapeLayer(
      this.edited,
      this.isClosed,
      this.pointRadiusBehaviour,
      this.points,
      do_objectID,
      booleanOperation,
      exportOptions,
      Frame frame,
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
      Style style,
      maintainScrollPosition)
      : super(
            do_objectID,
            booleanOperation,
            exportOptions,
            frame,
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
  Map<String, dynamic> toJson();
}
