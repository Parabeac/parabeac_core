import 'package:parabeac_core/design_logic/design_node.dart';
import 'package:parabeac_core/input/sketch/entities/objects/frame.dart';
import 'package:parabeac_core/input/sketch/entities/objects/override_value.dart';
import 'package:parabeac_core/input/sketch/helper/symbol_node_mixin.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/pb_shared_instance.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_context.dart';

import 'abstract_design_node_factory.dart';

class PBSharedInstanceDesignNode extends DesignNode
    with SymbolNodeMixin
    implements DesignNodeFactory {
  String symbolID;
  List parameters;

  PBSharedInstanceDesignNode(
      {String UUID,
      this.overrideValues,
      String name,
      bool isVisible,
      boundaryRectangle,
      String type,
      style,
      prototypeNode,
      exportOptions,
      booleanOperation,
      bool isFixedToViewport,
      bool isFlippedVertical,
      bool isFlippedHorizontal,
      bool isLocked,
      layerListExpandedType,
      bool nameIsFixed,
      resizingConstraint,
      resizingType,
      num rotation,
      sharedStyleID,
      bool shouldBreakMaskChain,
      bool hasClippingMask,
      int clippingMaskMode,
      userInfo,
      bool maintainScrollPosition,
      num scale,
      String symbolID,
      num verticalSpacing,
      num horizontalSpacing,
      pbdfType})
      : super(UUID, name, isVisible, boundaryRectangle, type, style,
            prototypeNode);

  @override
  String pbdfType = 'symbol_instance';

  @override
  DesignNode createDesignNode(Map<String, dynamic> json) => fromPBDF(json);

  DesignNode fromPBDF(Map<String, dynamic> json) {
    return PBSharedInstanceDesignNode(
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
      rotation: json['rotation'] as num,
      sharedStyleID: json['sharedStyleID'],
      shouldBreakMaskChain: json['shouldBreakMaskChain'] as bool,
      hasClippingMask: json['hasClippingMask'] as bool,
      clippingMaskMode: json['clippingMaskMode'] as int,
      userInfo: json['userInfo'],
      maintainScrollPosition: json['maintainScrollPosition'] as bool,
      overrideValues: (json['overrideValues'] as List)
          ?.map((e) => e == null
              ? null
              : OverridableValue.fromJson(e as Map<String, dynamic>))
          ?.toList(),
      scale: (json['scale'] as num)?.toDouble(),
      symbolID: json['symbolID'] as String,
      verticalSpacing: (json['verticalSpacing'] as num)?.toDouble(),
      horizontalSpacing: (json['horizontalSpacing'] as num)?.toDouble(),
      type: json['type'] as String,
      pbdfType: json['pbdfType'],
    )
      ..prototypeNodeUUID = json['prototypeNodeUUID'] as String
      ..parameters = json['parameters'] as List;
  }

  @override
  Future<PBIntermediateNode> interpretNode(PBContext currentContext) {
    var sym = PBSharedInstanceIntermediateNode(this, symbolID,
        sharedParamValues: _extractParameters(),
        currentContext: currentContext);
    return Future.value(sym);
  }

  ///Converting the [OverridableValue] into [PBSharedParameterValue] to be processed in intermediate phase.
  List<PBSharedParameterValue> _extractParameters() {
    Set<String> ovrNames = {};
    List<PBSharedParameterValue> sharedParameters = [];
    for (var overrideValue in overrideValues) {
      if (!ovrNames.contains(overrideValue.overrideName)) {
        var properties = extractParameter(overrideValue.overrideName);
        sharedParameters.add(PBSharedParameterValue(
            properties['type'],
            overrideValue.value,
            properties['uuid'],
            overrideValue.overrideName));
        ovrNames.add(overrideValue.overrideName);
      }
    }

    return sharedParameters;
  }

  final List<OverridableValue> overrideValues;
}
