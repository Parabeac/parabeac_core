import 'package:parabeac_core/input/figma/entities/abstract_figma_node_factory.dart';
import 'package:parabeac_core/input/figma/entities/layers/figma_node.dart';
import 'package:parabeac_core/input/figma/entities/style/figma_constraints.dart';
import 'package:parabeac_core/input/helper/figma_constraint_to_pbdl.dart';
import 'package:parabeac_core/input/sketch/entities/objects/frame.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/inherited_container.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_constraints.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_context.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:json_annotation/json_annotation.dart';
import 'dart:math';

part 'slice.g.dart';

@JsonSerializable(nullable: true)

///A slice is an invisible object with a bounding box,
///represented as dashed lines in the editor.
///Its purpose is to allow you to export a specific part of a document.
///Generally, the only thing you will do with a slice is to add an
///exportSettings and export its content via exportAsync.
class FigmaSlice extends FigmaNode implements FigmaNodeFactory {
  @override
  String type = 'SLICE';

  String layoutAlign;

  FigmaConstraints constraints;

  @override
  @JsonKey(name: 'absoluteBoundingBox')
  var boundaryRectangle;

  var size;

  FigmaSlice({
    String name,
    bool visible,
    String type,
    pluginData,
    sharedPluginData,
    this.layoutAlign,
    this.constraints,
    Frame this.boundaryRectangle,
    this.size,
    String prototypeNodeUUID,
    num transitionDuration,
    String transitionEasing,
  }) : super(
          name,
          visible,
          type,
          pluginData,
          sharedPluginData,
          prototypeNodeUUID: prototypeNodeUUID,
          transitionDuration: transitionDuration,
          transitionEasing: transitionEasing,
        ) {
    pbdfType = 'image';
  }

  @override
  FigmaNode createFigmaNode(Map<String, dynamic> json) =>
      FigmaSlice.fromJson(json);
  factory FigmaSlice.fromJson(Map<String, dynamic> json) =>
      _$FigmaSliceFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$FigmaSliceToJson(this);

  @override
  Future<PBIntermediateNode> interpretNode(PBContext currentContext) {
    return Future.value(InheritedContainer(
      this,
      Point(boundaryRectangle.x, boundaryRectangle.y),
      Point(boundaryRectangle.x + boundaryRectangle.width,
          boundaryRectangle.y + boundaryRectangle.height),
      name,
      currentContext: currentContext,
      constraints: PBIntermediateConstraints.fromConstraints(
          convertFigmaConstraintToPBDLConstraint(constraints),
          boundaryRectangle.height,
          boundaryRectangle.width),
    ));
  }

  @override
  bool isVisible;

  @override
  @JsonKey(ignore: true)
  var style;

  @override
  Map<String, dynamic> toPBDF() => toJson();

  @override
  String pbdfType = 'image';
}
