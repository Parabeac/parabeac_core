import 'package:json_annotation/json_annotation.dart';
import 'package:parabeac_core/input/figma/entities/abstract_figma_node_factory.dart';
import 'package:parabeac_core/input/figma/entities/layers/figma_node.dart';
import 'package:parabeac_core/input/sketch/entities/layers/flow.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/inherited_scaffold.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_context.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:parabeac_core/input/sketch/entities/objects/frame.dart';

part 'frame.g.dart';

@JsonSerializable(nullable: true)
class FigmaFrame extends FigmaNode implements FigmaNodeFactory {
  @override
  String UUID;

  @override
  @JsonKey(name: 'absoluteBoundingBox')
  var boundaryRectangle;

  @override
  bool isVisible;

  @override
  @JsonKey(name: 'transitionNodeID')
  String prototypeNodeUUID;

  @override
  var style;

  List<FigmaNode> children;

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

  String id;
  String name;
  bool visible;
  String type;

  FigmaFrame({
    this.id,
    this.name,
    this.visible,
    this.type,
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
    Flow flow,
  }) : super(
          id,
          name,
          visible,
          type,
          pluginData,
          sharedPluginData,
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
