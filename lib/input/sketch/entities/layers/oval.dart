import 'package:json_annotation/json_annotation.dart';
import 'package:parabeac_core/input/sketch/entities/abstract_sketch_node_factory.dart';
import 'package:parabeac_core/input/sketch/entities/layers/abstract_layer.dart';
import 'package:parabeac_core/input/sketch/entities/layers/abstract_shape_layer.dart';
import 'package:parabeac_core/input/sketch/entities/layers/flow.dart';
import 'package:parabeac_core/input/sketch/entities/objects/frame.dart';
import 'package:parabeac_core/input/sketch/entities/style/style.dart';
import 'package:parabeac_core/input/sketch/helper/sketch_asset_processor.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/inherited_oval.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_context.dart';

part 'oval.g.dart';

// title: Oval Layer
// description: Oval layers are the result of adding an oval shape to the canvas
@JsonSerializable(nullable: true)
class Oval extends AbstractShapeLayer implements SketchNodeFactory {
  @override
  String CLASS_NAME = 'oval';
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
  set isVisible(bool _isVisible) => this._isVisible = _isVisible;

  @override
  bool get isVisible => _isVisible;

  @override
  set style(_style) => this._style = _style;

  @override
  Style get style => _style;
  Oval(
      {bool edited,
      bool isClosed,
      pointRadiusBehaviour,
      List points,
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
            edited,
            isClosed,
            pointRadiusBehaviour,
            points,
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
  SketchNode createSketchNode(Map<String, dynamic> json) {
    var oval = Oval.fromJson(json);
    return oval;
  }

  factory Oval.fromJson(Map<String, dynamic> json) => _$OvalFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$OvalToJson(this);

  @override
  Future<PBIntermediateNode> interpretNode(PBContext currentContext) async {
    var image = await SketchAssetProcessor()
        .processImage(UUID, boundaryRectangle.width, boundaryRectangle.height);

    return Future.value(InheritedOval(this, name,
        currentContext: currentContext,
        image: image,
        constraints: resizingConstraint));
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
        'edited': edited,
        'isClosed': isClosed,
        'pointRadiusBehaviour': pointRadiusBehaviour,
        'points': points,
        'CLASS_NAME': CLASS_NAME,
        'absoluteBoundingBox': boundaryRectangle,
        'id': UUID,
        'type': type,
        'visible': isVisible,
        'style': style,
        'pbdfType': pbdfType,
      };

  @override
  @JsonKey(ignore: true)
  String pbdfType = 'oval';
}
