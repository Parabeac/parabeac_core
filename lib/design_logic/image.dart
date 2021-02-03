import 'dart:io';

import 'package:parabeac_core/controllers/main_info.dart';
import 'package:parabeac_core/design_logic/design_element.dart';
import 'package:parabeac_core/design_logic/design_node.dart';
import 'package:parabeac_core/design_logic/pb_style.dart';
import 'package:parabeac_core/input/helper/azure_asset_service.dart';
import 'package:parabeac_core/input/sketch/entities/objects/frame.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/inherited_bitmap.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_context.dart';

import 'abstract_design_node_factory.dart';

class Image extends DesignElement implements DesignNodeFactory, DesignNode {
  @override
  var style;

  Image({
    this.imageReference,
    UUID,
    booleanOperation,
    exportOptions,
    Frame boundaryRectangle,
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
    num rotation,
    sharedStyleID,
    shouldBreakMaskChain,
    hasClippingMask,
    clippingMaskMode,
    userInfo,
    maintainScrollPosition,
    this.pbdfType = 'image',
    this.style,
  }) : super(
          UUID: UUID,
          name: name,
          isVisible: isVisible,
          boundaryRectangle: boundaryRectangle,
          style: style,
        );

  String imageReference;

  @override
  String pbdfType = 'image';

  @override
  DesignNode createDesignNode(Map<String, dynamic> json) => fromPBDF(json);

  DesignNode fromPBDF(Map<String, dynamic> json) {
    return Image(
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
      rotation: json['rotation'] as num,
      sharedStyleID: json['sharedStyleID'],
      shouldBreakMaskChain: json['shouldBreakMaskChain'],
      hasClippingMask: json['hasClippingMask'],
      clippingMaskMode: json['clippingMaskMode'],
      userInfo: json['userInfo'],
      maintainScrollPosition: json['maintainScrollPosition'],
      pbdfType: json['pbdfType'],
      style: json['style'] == null
          ? null
          : PBStyle.fromPBDF(json['style'] as Map<String, dynamic>),
    )
      ..prototypeNodeUUID = json['prototypeNodeUUID'] as String
      ..type = json['type'] as String;
  }

  @override
  Future<PBIntermediateNode> interpretNode(PBContext currentContext) async {
    var img = await AzureAssetService().downloadImage(UUID);
    var file =
        File('${MainInfo().outputPath}pngs/${UUID}.png'.replaceAll(':', '_'))
          ..createSync(recursive: true);
    file.writeAsBytesSync(img);
    return Future.value(InheritedBitmap(
      this,
      name,
      currentContext: currentContext,
    ));
  }
}
