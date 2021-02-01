import 'package:parabeac_core/design_logic/design_element.dart';
import 'package:parabeac_core/design_logic/design_node.dart';
import 'package:parabeac_core/input/sketch/entities/objects/frame.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/inherited_text.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/injected_container.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_context.dart';
import 'package:parabeac_core/interpret_and_optimize/value_objects/point.dart';
import 'package:uuid/uuid.dart';

import 'abstract_design_node_factory.dart';

class Text extends DesignElement implements DesignNodeFactory, DesignNode {
  @override
  var boundaryRectangle;

  @override
  var UUID;

  var attributedString;

  var automaticallyDrawOnUnderlyingPath;

  var dontSynchroniseWithSymbol;

  var lineSpacingBehaviour;

  var textBehaviour;

  var glyphBounds;

  Text({
    this.UUID,
    booleanOperation,
    exportOptions,
    Frame this.boundaryRectangle,
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
    double rotation,
    sharedStyleID,
    bool shouldBreakMaskChain,
    bool hasClippingMask,
    int clippingMaskMode,
    bool maintainScrollPosition,
    this.attributedString,
    this.automaticallyDrawOnUnderlyingPath,
    this.dontSynchroniseWithSymbol,
    this.lineSpacingBehaviour,
    this.textBehaviour,
    this.glyphBounds,
    type,
    pbdfType,
  });

  String content;

  @override
  String pbdfType = 'text';

  @override
  DesignNode createDesignNode(Map<String, dynamic> json) => fromPBDF(json);

  DesignNode fromPBDF(Map<String, dynamic> json) {
    return Text(
      UUID: json['id'] as String,
      booleanOperation: json['booleanOperation'],
      exportOptions: json['exportOptions'],
      boundaryRectangle: json['absoluteBoundingBox'] == null
          ? null
          : Frame.fromJson(json['absoluteBoundingBox'] as Map<String, dynamic>),
      isFixedToViewport: json['isFixedToViewport'] as bool,
      isFlippedHorizontal: json['isFlippedHorizontal'] as bool,
      isFlippedVertical: json['isFlippedVertical'] as bool,
      isLocked: json['isLocked'] as bool,
      isVisible: json['visible'] as bool,
      layerListExpandedType: json['layerListExpandedType'],
      name: json['name'] as String,
      nameIsFixed: json['nameIsFixed'] as bool,
      resizingConstraint: json['resizingConstraint'],
      resizingType: json['resizingType'],
      rotation: (json['rotation'] as num)?.toDouble(),
      sharedStyleID: json['sharedStyleID'],
      shouldBreakMaskChain: json['shouldBreakMaskChain'] as bool,
      hasClippingMask: json['hasClippingMask'] as bool,
      clippingMaskMode: json['clippingMaskMode'] as int,
      maintainScrollPosition: json['maintainScrollPosition'] as bool,
      attributedString: json['attributedString'] as Map<String, dynamic>,
      automaticallyDrawOnUnderlyingPath:
          json['automaticallyDrawOnUnderlyingPath'] as bool,
      dontSynchroniseWithSymbol: json['dontSynchroniseWithSymbol'] as bool,
      lineSpacingBehaviour: json['lineSpacingBehaviour'],
      textBehaviour: json['textBehaviour'],
      glyphBounds: json['glyphBounds'],
      type: json['type'] as String,
      pbdfType: json['pbdfType'],
    );
  }

  @override
  Future<PBIntermediateNode> interpretNode(PBContext currentContext) =>
      Future.value(InjectedContainer(
        Point(boundaryRectangle.x + boundaryRectangle.width,
            boundaryRectangle.y + boundaryRectangle.height),
        Point(boundaryRectangle.x, boundaryRectangle.y),
        name,
        Uuid().v4(),
        currentContext: currentContext,
      )..addChild(
          InheritedText(this, name, currentContext: currentContext),
        ));
}
