import 'package:json_annotation/json_annotation.dart';
import 'package:parabeac_core/design_logic/artboard.dart';
import 'package:parabeac_core/design_logic/design_node.dart';
import 'package:parabeac_core/input/sketch/entities/abstract_sketch_node_factory.dart';
import 'package:parabeac_core/input/sketch/entities/layers/abstract_group_layer.dart';
import 'package:parabeac_core/input/sketch/entities/layers/abstract_layer.dart';
import 'package:parabeac_core/input/sketch/entities/layers/flow.dart';
import 'package:parabeac_core/input/sketch/entities/objects/frame.dart';
import 'package:parabeac_core/input/sketch/entities/style/color.dart';
import 'package:parabeac_core/input/sketch/entities/style/style.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/inherited_scaffold.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_context.dart';

part 'artboard.g.dart';

@JsonSerializable(nullable: true)
class Artboard extends AbstractGroupLayer
    implements SketchNodeFactory, PBArtboard {
  @override
  @JsonKey(name: 'layers')
  List children;

  @override
  String CLASS_NAME = 'artboard';
  @override
  @JsonKey(name: '_class')
  String type;
  final bool includeInCloudUpload;
  final bool includeBackgroundColorInExport;
  final dynamic horizontalRulerData;
  final dynamic verticalRulerData;
  final dynamic layout;
  final dynamic grid;

  @override
  @JsonKey(name: 'frame')
  var boundaryRectangle;

  @override
  var backgroundColor;

  @override
  @JsonKey(name: 'do_objectID')
  String UUID;

  final bool hasBackgroundColor;
  @override
  final bool isFlowHome;
  final bool resizesContent;
  final dynamic presetDictionary;

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

  Artboard(
      {this.includeInCloudUpload,
      this.includeBackgroundColorInExport,
      this.horizontalRulerData,
      this.verticalRulerData,
      this.layout,
      this.grid,
      Color this.backgroundColor,
      this.hasBackgroundColor,
      this.isFlowHome,
      this.resizesContent,
      this.presetDictionary,
      hasClickThrough,
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
            (children as List<SketchNode>),
            UUID,
            booleanOperation,
            exportOptions,
            boundaryRectangle as Frame,
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
  SketchNode createSketchNode(Map<String, dynamic> json) =>
      Artboard.fromJson(json);
  factory Artboard.fromJson(Map<String, dynamic> json) =>
      _$ArtboardFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$ArtboardToJson(this);

  @override
  Future<PBIntermediateNode> interpretNode(PBContext currentContext) {
    return Future.value(InheritedScaffold(
      this,
      currentContext: currentContext,
      name: name,
      isHomeScreen: isFlowHome,
    ));
  }

  @override
  Map<String, dynamic> toPBDF() => <String, dynamic>{
        // Change _class for type and layers for children and do_objectID for id
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
        'children': getChildren(), // changed it was layers
        'CLASS_NAME': CLASS_NAME,
        'type': type, // changed it was _class
        'includeInCloudUpload': includeInCloudUpload,
        'includeBackgroundColorInExport': includeBackgroundColorInExport,
        'horizontalRulerData': horizontalRulerData,
        'verticalRulerData': verticalRulerData,
        'layout': layout,
        'grid': grid,
        'absoluteBoundingBox': boundaryRectangle, // changed it was frame
        'backgroundColor': backgroundColor,
        'id': UUID, // changed it was do_objectID
        'hasBackgroundColor': hasBackgroundColor,
        'isFlowHome': isFlowHome,
        'resizesContent': resizesContent,
        'presetDictionary': presetDictionary,
        'visible': isVisible, // changed it was isVisible
        'style': style,
        'pbdfType': pbdfType,
      };

  @override
  @JsonKey(ignore: true)
  String pbdfType = 'artboard';

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

  @override
  set isFlowHome(_isFlowHome) {
    // TODO: implement isFlowHome
  }
}
