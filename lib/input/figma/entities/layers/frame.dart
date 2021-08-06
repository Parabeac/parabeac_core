import 'package:json_annotation/json_annotation.dart';
import 'package:parabeac_core/design_logic/artboard.dart';
import 'package:parabeac_core/design_logic/color.dart';
import 'package:parabeac_core/design_logic/design_node.dart';
import 'package:parabeac_core/design_logic/group_node.dart';
import 'package:parabeac_core/design_logic/image.dart';
import 'package:parabeac_core/input/figma/entities/abstract_figma_node_factory.dart';
import 'package:parabeac_core/input/figma/entities/layers/figma_node.dart';
import 'package:parabeac_core/input/figma/entities/layers/group.dart';
import 'package:parabeac_core/input/figma/entities/style/figma_color.dart';
import 'package:parabeac_core/input/figma/entities/style/figma_constraints.dart';
import 'package:parabeac_core/input/figma/helper/style_extractor.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/inherited_scaffold.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_context.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:parabeac_core/input/sketch/entities/objects/frame.dart';

part 'frame.g.dart';

@JsonSerializable(nullable: true)
class FigmaFrame extends FigmaNode
    with PBColorMixin
    implements FigmaNodeFactory, GroupNode, PBArtboard, Image {
  @override
  @JsonKey(name: 'absoluteBoundingBox')
  var boundaryRectangle;

  @override
  @JsonKey(ignore: true)
  var style;

  @override
  List children;

  @JsonKey(ignore: true)
  var fills;

  var strokes;

  double strokeWeight;

  String strokeAlign;

  double cornerRadius;

  FigmaConstraints constraints;

  String layoutAlign;

  var size;

  double horizontalPadding;

  double verticalPadding;

  double itemSpacing;

  @override
  PBColor backgroundColor;

  @override
  String type = 'FRAME';

  @JsonKey(ignore: true)
  bool isScaffold = false;

  @override
  @JsonKey(nullable: true, defaultValue: false)
  var isFlowHome = false;

  FigmaFrame({
    name,
    isVisible,
    type,
    pluginData,
    sharedPluginData,
    Frame this.boundaryRectangle,
    this.style,
    this.fills,
    this.strokes,
    this.strokeWeight,
    this.strokeAlign,
    this.cornerRadius,
    this.constraints,
    this.layoutAlign,
    this.size,
    this.horizontalPadding,
    this.verticalPadding,
    this.itemSpacing,
    List<FigmaNode> this.children,
    String UUID,
    FigmaColor this.backgroundColor,
    String transitionNodeID,
    num transitionDuration,
    String transitionEasing,
    String prototypeNodeUUID,
  }) : super(
          name,
          isVisible,
          type,
          pluginData,
          sharedPluginData,
          UUID: UUID,
          prototypeNodeUUID: prototypeNodeUUID,
          transitionDuration: transitionDuration,
          transitionEasing: transitionEasing,
        ) {
    pbdfType = 'group';
  }
  @JsonKey(ignore: true)
  List points;

  @JsonKey(name: 'fills')
  List fillsList;

  @override
  FigmaNode createFigmaNode(Map<String, dynamic> json) {
    var node = FigmaFrame.fromJson(json);
    node.style = StyleExtractor().getStyle(json);
    return node;
  }

  factory FigmaFrame.fromJson(Map<String, dynamic> json) =>
      _$FigmaFrameFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$FigmaFrameToJson(this);

  @override
  Future<PBIntermediateNode> interpretNode(PBContext currentContext) {
    /// TODO: change `isHomeScreen` to its actual value
    if (isScaffold) {
      return Future.value(InheritedScaffold(
        this,
        currentContext: currentContext,
        name: name,
        isHomeScreen: isFlowHome,
      ));
    } else {
      var tempGroup = Group(
        name: name,
        isVisible: isVisible,
        type: type,
        pluginData: pluginData,
        sharedPluginData: sharedPluginData,
        boundaryRectangle: boundaryRectangle,
        style: style,
        fills: fills,
        strokes: strokes,
        strokeWeight: strokeWeight,
        strokeAlign: strokeAlign,
        cornerRadius: cornerRadius,
        constraints: constraints,
        layoutAlign: layoutAlign,
        size: size,
        horizontalPadding: horizontalPadding,
        verticalPadding: verticalPadding,
        itemSpacing: itemSpacing,
        children: children,
        UUID: UUID,
        backgroundColor: backgroundColor,
        prototypeNodeUUID: prototypeNodeUUID,
        transitionDuration: transitionDuration,
        transitionEasing: transitionEasing,
      );

      return Future.value(tempGroup.interpretNode(currentContext));
    }
  }

  @override
  String imageReference;

  @override
  Map<String, dynamic> toPBDF() => toJson();

  @override
  String pbdfType = 'group';

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
