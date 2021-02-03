import 'package:parabeac_core/design_logic/design_node.dart';
import 'package:parabeac_core/input/helper/azure_asset_service.dart';
import 'package:parabeac_core/input/sketch/entities/objects/frame.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/inherited_star.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_context.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:parabeac_core/design_logic/pb_style.dart';

import 'abstract_design_node_factory.dart';

class Star implements DesignNodeFactory, DesignNode {
  @override
  String pbdfType = 'star';

  Star({
    bool edited,
    bool isClosed,
    pointRadiusBehaviour,
    List points,
    this.UUID,
    booleanOperation,
    exportOptions,
    Frame this.boundaryRectangle,
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
    maintainScrollPosition,
    type,
    pbdfType,
    this.style,
  });

  @override
  DesignNode createDesignNode(Map<String, dynamic> json) => fromPBDF(json);

  DesignNode fromPBDF(Map<String, dynamic> json) {
    return Star(
      edited: json['edited'] as bool,
      isClosed: json['isClosed'] as bool,
      pointRadiusBehaviour: json['pointRadiusBehaviour'],
      points: json['points'] as List,
      UUID: json['do_objectID'] as String,
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
      type: json['_class'] as String,
      pbdfType: json['pbdfType'],
      style: json['style'] == null
          ? null
          : PBStyle.fromPBDF(json['style'] as Map<String, dynamic>),
    );
  }

  @override
  String UUID;

  @override
  var boundaryRectangle;

  @override
  bool isVisible;

  @override
  String name;

  @override
  String prototypeNodeUUID;

  @override
  PBStyle style;

  @override
  String type;

  @override
  Future<PBIntermediateNode> interpretNode(PBContext currentContext) async {
    var img = await AzureAssetService().downloadImage(UUID);
    return Future.value(
        InheritedStar(this, name, currentContext: currentContext, image: img));
  }

  @override
  toJson() {
    throw UnimplementedError();
  }

  @override
  Map<String, dynamic> toPBDF() {
    throw UnimplementedError();
  }
}
