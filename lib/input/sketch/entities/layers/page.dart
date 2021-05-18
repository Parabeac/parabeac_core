import 'package:parabeac_core/design_logic/design_node.dart';
import 'package:parabeac_core/input/sketch/entities/abstract_sketch_node_factory.dart';
import 'package:parabeac_core/input/sketch/entities/layers/abstract_group_layer.dart';
import 'package:parabeac_core/input/sketch/entities/layers/abstract_layer.dart';
import 'package:parabeac_core/input/sketch/entities/layers/flow.dart';
import 'package:parabeac_core/input/sketch/entities/objects/frame.dart';
import 'package:parabeac_core/input/sketch/entities/style/style.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_context.dart';

part 'page.g.dart';

// title: Page Layer
// description:
//   Page layers are the top level organisational abstraction within a document
@JsonSerializable(nullable: true)
class Page extends AbstractGroupLayer implements SketchNodeFactory {
  @override
  String CLASS_NAME = 'page';
  dynamic includeInCloudUpload;
  dynamic horizontalRulerData;
  dynamic verticalRulerData;
  dynamic layout;
  dynamic grid;

  @override
  @JsonKey(name: 'frame')
  var boundaryRectangle;

  @override
  @JsonKey(name: 'do_objectID')
  String UUID;

  @override
  @JsonKey(name: '_class')
  String type;

  bool _isVisible;

  Style _style;

  @override
  @JsonKey(name: 'layers')
  List children;

  @override
  set isVisible(bool _isVisible) => this._isVisible = _isVisible;

  @override
  bool get isVisible => _isVisible;

  @override
  set style(_style) => this._style = _style;

  @override
  Style get style => _style;

  Page(
      {bool hasClickThrough,
      groupLayout,
      List<SketchNode> this.children,
      this.UUID,
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
      maintainScrollPosition})
      : _isVisible = isVisible,
        _style = style,
        super(
            hasClickThrough,
            groupLayout,
            children,
            UUID,
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
  SketchNode createSketchNode(Map<String, dynamic> json) => Page.fromJson(json);
  factory Page.fromJson(Map<String, dynamic> json) => _$PageFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$PageToJson(this);

  @override
  Future<PBIntermediateNode> interpretNode(PBContext currentContext) {
    assert(false, 'We don\'t product pages as Intermediate Nodes.');
    return null;
  }

  @override
  Map<String, dynamic> toPBDF() => <String, dynamic>{
        'booleanOperation': booleanOperation,
        'exportOptions': exportOptions,
        'flow': flow,
        'isFixedToViewport': isFixedToViewport,
        'isFlippedHorizontal': isFlippedHorizontal,
        'isFlippedVertical': isFlippedVertical,
        'isLocked': isLocked,
        'layerListExpandedType': layerListExpandedType,
        'name': name,
        'nameIsFixed': nameIsFixed,
        'resizingConstraint': resizingConstraint,
        'resizingType': resizingType,
        'rotation': rotation,
        'sharedStyleID': sharedStyleID,
        'shouldBreakMaskChain': shouldBreakMaskChain,
        'hasClippingMask': hasClippingMask,
        'clippingMaskMode': clippingMaskMode,
        'userInfo': userInfo,
        'maintainScrollPosition': maintainScrollPosition,
        'prototypeNodeUUID': prototypeNodeUUID,
        'hasClickThrough': hasClickThrough,
        'groupLayout': groupLayout,
        'CLASS_NAME': CLASS_NAME,
        'includeInCloudUpload': includeInCloudUpload,
        'horizontalRulerData': horizontalRulerData,
        'verticalRulerData': verticalRulerData,
        'layout': layout,
        'grid': grid,
        'absoluteBoundingBox': boundaryRectangle,
        'id': UUID,
        'type': type,
        'children': getChildren(),
        'visible': isVisible,
        'style': style,
        'pbdfType': pbdfType,
      };

  @override
  @JsonKey(ignore: true)
  String pbdfType = 'page';

  @override
  DesignNode createDesignNode(Map<String, dynamic> json) {
    // TODO: implement createDesignNode
    throw UnimplementedError();
  }

  @override
  DesignNode fromPBDF(Map<String, dynamic> json) {
    // TODO: implement fromPBDF
    throw UnimplementedError();
  }
}
