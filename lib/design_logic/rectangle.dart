import 'package:parabeac_core/design_logic/design_node.dart';
import 'package:parabeac_core/input/sketch/entities/objects/frame.dart';
import 'package:parabeac_core/input/sketch/entities/style/border.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/inherited_container.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_context.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:parabeac_core/design_logic/pb_style.dart';
import 'package:parabeac_core/interpret_and_optimize/value_objects/point.dart';

import 'abstract_design_node_factory.dart';
import 'color.dart';

class Rectangle with PBColorMixin implements DesignNodeFactory, DesignNode {
  @override
  String pbdfType = 'rectangle';

  var hasConvertedToNewRoundCorners;

  var fixedRadius;

  var needsConvertionToNewRoundCorners;

  var points;

  Rectangle({
    this.fixedRadius,
    this.hasConvertedToNewRoundCorners,
    this.needsConvertionToNewRoundCorners,
    bool edited,
    bool isClosed,
    pointRadiusBehaviour,
    List this.points,
    this.UUID,
    booleanOperation,
    exportOptions,
    Frame this.boundaryRectangle,
    isFixedToViewport,
    isFlippedHorizontal,
    isFlippedVertical,
    isLocked,
    this.isVisible,
    layerListExpandedType,
    this.name,
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
    this.type,
    this.pbdfType,
    this.style,
  });

  @override
  DesignNode createDesignNode(Map<String, dynamic> json) => fromPBDF(json);

  DesignNode fromPBDF(Map<String, dynamic> json) {
    return Rectangle(
      fixedRadius: (json['fixedRadius'] as num)?.toDouble(),
      hasConvertedToNewRoundCorners:
          json['hasConvertedToNewRoundCorners'] as bool,
      needsConvertionToNewRoundCorners:
          json['needsConvertionToNewRoundCorners'] as bool,
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
      isVisible: json['isVisible'],
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
      type: json['type'] as String,
      maintainScrollPosition: json['maintainScrollPosition'],
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
  Future<PBIntermediateNode> interpretNode(PBContext currentContext) {
    Border border;
    for (var b in style.borders.reversed) {
      if (b.isEnabled) {
        border = b;
      }
    }
    return Future.value(InheritedContainer(
      this,
      Point(boundaryRectangle.x, boundaryRectangle.y),
      Point(boundaryRectangle.x + boundaryRectangle.width,
          boundaryRectangle.y + boundaryRectangle.height),
      name,
      currentContext: currentContext,
      borderInfo: {
        'borderRadius':
            style.borderOptions.isEnabled ? points[0]['cornerRadius'] : null,
        'borderColorHex': border != null ? toHex(border.color) : null,
        'borderThickness': border != null ? border.thickness : null
      },
    ));
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
