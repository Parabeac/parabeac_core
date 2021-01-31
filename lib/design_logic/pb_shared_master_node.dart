import 'package:parabeac_core/design_logic/design_node.dart';
import 'package:parabeac_core/design_logic/group_node.dart';
import 'package:parabeac_core/input/sketch/entities/objects/frame.dart';
import 'package:parabeac_core/input/sketch/entities/objects/override_property.dart';

import 'abstract_design_node_factory.dart';

class PBSharedMasterDesignNode extends DesignNode
    implements DesignNodeFactory, GroupNode {
  String symbolID;
  List overriadableProperties;

  PBSharedMasterDesignNode(
      {String UUID,
      String name,
      bool isVisible,
      boundaryRectangle,
      String type,
      style,
      prototypeNode,
      bool hasClickThrough,
      groupLayout,
      booleanOperation,
      exportOptions,
      isFixedToViewport,
      isFlippedHorizontal,
      isFlippedVertical,
      isLocked,
      layerListExpandedType,
      pbdfType,
      presetDictionary,
      List<OverridableProperty> overrideProperties,
      bool allowsOverrides,
      nameIsFixed,
      resizingConstraint,
      resizingType,
      horizontalRulerData,
      bool hasBackgroundColor,
      rotation,
      sharedStyleID,
      shouldBreakMaskChain,
      hasClippingMask,
      clippingMaskMode,
      userInfo,
      maintainScrollPosition,
      bool includeBackgroundColorInExport,
      int changeIdentifier,
      String symbolID,
      bool includeBackgroundColorInInstance,
      verticalRulerData,
      bool resizesContent,
      bool includeInCloudUpload,
      bool isFlowHome,
      List parameters})
      : super(UUID, name, isVisible, boundaryRectangle, type, style,
            prototypeNode);

  @override
  String pbdfType = 'symbol_master';

  @override
  DesignNode createDesignNode(Map<String, dynamic> json) => fromPBDF(json);

  DesignNode fromPBDF(Map<String, dynamic> json) {
    var node = PBSharedMasterDesignNode(
      hasClickThrough: json['hasClickThrough'] as bool,
      groupLayout: json['groupLayout'],
      UUID: json['id'] as String,
      booleanOperation: json['booleanOperation'],
      exportOptions: json['exportOptions'],
      boundaryRectangle: json['absoluteBoundingBox'] == null
          ? null
          : Frame.fromJson(json['absoluteBoundingBox'] as Map<String, dynamic>),
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
      maintainScrollPosition: json['maintainScrollPosition'],
      hasBackgroundColor: json['hasBackgroundColor'] as bool,
      horizontalRulerData: json['horizontalRulerData'],
      includeBackgroundColorInExport:
          json['includeBackgroundColorInExport'] as bool,
      includeInCloudUpload: json['includeInCloudUpload'] as bool,
      isFlowHome: json['isFlowHome'] as bool,
      resizesContent: json['resizesContent'] as bool,
      verticalRulerData: json['verticalRulerData'],
      includeBackgroundColorInInstance:
          json['includeBackgroundColorInInstance'] as bool,
      symbolID: json['symbolID'] as String,
      changeIdentifier: json['changeIdentifier'] as int,
      allowsOverrides: json['allowsOverrides'] as bool,
      overrideProperties: (json['overrideProperties'] as List)
          ?.map((e) => e == null
              ? null
              : OverridableProperty.fromJson(e as Map<String, dynamic>))
          ?.toList(),
      presetDictionary: json['presetDictionary'],
      type: json['type'] as String,
      pbdfType: json['pbdfType'],
      parameters: json['parameters'] as List,
    )..prototypeNodeUUID = json['prototypeNodeUUID'] as String;

    if (json.containsKey('children')) {
      if (json['children'] != null) {
        node.children
            .add(DesignNode.fromPBDF(json['children'] as Map<String, dynamic>));
      }
    }
    return node;
  }

  @override
  List children = [];
}
