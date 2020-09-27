import 'package:json_annotation/json_annotation.dart';
import 'package:parabeac_core/design_logic/group_node.dart';
import 'package:parabeac_core/input/figma/entities/abstract_figma_node_factory.dart';
import 'package:parabeac_core/input/figma/entities/layers/figma_node.dart';
import 'package:parabeac_core/input/sketch/entities/layers/flow.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/inherited_scaffold.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_context.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:parabeac_core/input/sketch/entities/objects/frame.dart';

part 'frame.g.dart';

@JsonSerializable(nullable: true)
class FigmaFrame extends FigmaNode implements FigmaNodeFactory, GroupNode {
  @override
  @JsonKey(name: 'absoluteBoundingBox')
  var boundaryRectangle;

  @override
  @JsonKey(name: 'transitionNodeID')
  String prototypeNodeUUID;

  @override
  var style;

  @override
  List children;

  var fills;

  var strokes;

  double strokeWeight;

  String strokeAlign;

  double cornerRadius;

  var constraints;

  String layoutAlign;

  var size;

  double horizontalPadding;

  double verticalPadding;

  double itemSpacing;

  @override
  String type = 'FRAME';

  FigmaFrame(
      {name,
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
      Flow flow,
      String UUID})
      : super(
          name,
          isVisible,
          type,
          pluginData,
          sharedPluginData,
          UUID: UUID,
        );

  @override
  FigmaNode createFigmaNode(Map<String, dynamic> json) =>
      FigmaFrame.fromJson(json);
  factory FigmaFrame.fromJson(Map<String, dynamic> json) =>
      _$FigmaFrameFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$FigmaFrameToJson(this);

  @override
  Future<PBIntermediateNode> interpretNode(PBContext currentContext) {
    return Future.value(InheritedScaffold(
      this,
      currentContext: currentContext,
      name: name,
      isHomeScreen: null,
    ));
  }
}
