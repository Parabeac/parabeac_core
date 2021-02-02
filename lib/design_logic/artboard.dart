import 'package:parabeac_core/design_logic/color.dart';
import 'package:parabeac_core/design_logic/design_node.dart';
import 'package:parabeac_core/design_logic/group_node.dart';
import 'package:parabeac_core/design_logic/rect.dart';
import 'package:parabeac_core/input/sketch/entities/layers/flow.dart';
import 'package:parabeac_core/input/sketch/entities/objects/frame.dart';
import 'package:parabeac_core/input/sketch/entities/style/color.dart';
import 'package:parabeac_core/input/sketch/entities/style/style.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/inherited_scaffold.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_context.dart';

import 'abstract_design_node_factory.dart';

class PBArtboard extends DesignNode implements GroupNode, DesignNodeFactory {
  PBColor backgroundColor;
  @override
  var boundaryRectangle;
  var isFlowHome;
  PBArtboard(
      {Color this.backgroundColor,
      this.isFlowHome,
      hasClickThrough,
      groupLayout,
      UUID,
      booleanOperation,
      exportOptions,
      Frame this.boundaryRectangle,
      Flow flow,
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
      maintainScrollPosition,
      prototypeNode,
      type})
      : super(UUID, name, isVisible, boundaryRectangle, type, style,
            prototypeNode);

  @override
  List children = [];

  @override
  String pbdfType = 'artboard';

  @override
  DesignNode createDesignNode(Map<String, dynamic> json) => fromPBDF(json);

  DesignNode fromPBDF(Map<String, dynamic> json) {
    var node = PBArtboard(
      backgroundColor: json['backgroundColor'] == null
          ? null
          : Color.fromJson(json['backgroundColor'] as Map<String, dynamic>),
      isFlowHome: json['isFlowHome'] as bool,
      hasClickThrough: json['hasClickThrough'],
      groupLayout: json['groupLayout'],
      UUID: json['id'] as String,
      booleanOperation: json['booleanOperation'],
      exportOptions: json['exportOptions'],
      boundaryRectangle: json['absoluteBoundingBox'] == null
          ? null
          : Frame.fromJson(json['absoluteBoundingBox'] as Map<String, dynamic>),
      flow: json['flow'] == null
          ? null
          : Flow.fromJson(json['flow'] as Map<String, dynamic>),
      isFixedToViewport: json['isFixedToViewport'],
      isFlippedHorizontal: json['isFlippedHorizontal'],
      isFlippedVertical: json['isFlippedVertical'],
      isLocked: json['isLocked'],
      isVisible: json['visible'],
      layerListExpandedType: json['layerListExpandedType'],
      name: json['name'],
      nameIsFixed: json['nameIsFixed'],
      resizingConstraint: json['resizingConstraint'],
      resizingType: json['resizingType'],
      rotation: json['rotation'],
      sharedStyleID: json['sharedStyleID'],
      shouldBreakMaskChain: json['shouldBreakMaskChain'],
      hasClippingMask: json['hasClippingMask'],
      clippingMaskMode: json['clippingMaskMode'],
      userInfo: json['userInfo'],
      style: json['style'] == null
          ? null
          : Style.fromJson(json['style'] as Map<String, dynamic>),
      maintainScrollPosition: json['maintainScrollPosition'],
    )
      ..prototypeNodeUUID = json['prototypeNodeUUID'] as String
      ..type = json['type'] as String;
    if (json.containsKey('children')) {
      if (json['children'] != null) {
        node.children
            .add(DesignNode.fromPBDF(json['children'] as Map<String, dynamic>));
      }
    }
    return node;
  }

  @override
  Future<PBIntermediateNode> interpretNode(PBContext currentContext) {
    return Future.value(InheritedScaffold(
      this,
      currentContext: currentContext,
      name: name,
      isHomeScreen: isFlowHome,
    ));
  }
}
