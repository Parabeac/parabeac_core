import 'dart:math';
import 'dart:typed_data';
import 'package:parabeac_core/controllers/main_info.dart';
import 'package:parabeac_core/generation/generators/visual-widgets/pb_bitmap_gen.dart';
import 'package:parabeac_core/generation/prototyping/pb_prototype_node.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/inherited_shape_path.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/interfaces/pb_inherited_intermediate.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_constraints.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_visual_intermediate_node.dart';
<<<<<<< HEAD
import 'package:parabeac_core/interpret_and_optimize/helpers/align_strategy.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/child_strategy.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_context.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_image_reference_storage.dart';
=======
import 'package:parabeac_core/interpret_and_optimize/helpers/abstract_intermediate_node_factory.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_context.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_image_reference_storage.dart';
import 'package:parabeac_core/interpret_and_optimize/value_objects/point.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:parabeac_core/interpret_and_optimize/state_management/intermediate_auxillary_data.dart';
>>>>>>> origin/feat/pbdl-interpret

part 'inherited_star.g.dart';

@JsonSerializable()
class InheritedStar extends PBVisualIntermediateNode
    implements PBInheritedIntermediate, IntermediateNodeFactory {
  @override
  @JsonKey(
      fromJson: PrototypeNode.prototypeNodeFromJson, name: 'prototypeNodeUUID')
  PrototypeNode prototypeNode;

  @override
<<<<<<< HEAD
  PrototypeNode prototypeNode;
  
  @override
  ChildrenStrategy childrenStrategy = NoChildStrategy();

  InheritedStar(this.originalRef, String name,
      {Uint8List image,
      PBContext currentContext,
      PBIntermediateConstraints constraints})
      : super(
            Point(originalRef.boundaryRectangle.x,
                originalRef.boundaryRectangle.y),
            Point(
                originalRef.boundaryRectangle.x +
                    originalRef.boundaryRectangle.width,
                originalRef.boundaryRectangle.y +
                    originalRef.boundaryRectangle.height),
            currentContext,
            name,
            UUID: originalRef.UUID ?? '',
            constraints: constraints) {
    if (originalRef is DesignNode && originalRef.prototypeNodeUUID != null) {
      prototypeNode = PrototypeNode(originalRef?.prototypeNodeUUID);
    }
    generator = PBBitmapGenerator();
=======
  @JsonKey(ignore: true)
  Point topLeftCorner;
  @override
  @JsonKey(ignore: true)
  Point bottomRightCorner;

  @override
  @JsonKey()
  String type = 'star';

  @override
  String UUID;
>>>>>>> origin/feat/pbdl-interpret

  @override
  @JsonKey(fromJson: PBIntermediateNode.sizeFromJson, name: 'boundaryRectangle')
  Map size;

  @override
  @JsonKey(ignore: true)
  PBContext currentContext;

  @override
  @JsonKey(ignore: true)
  Map<String, dynamic> originalRef;

  InheritedStar({
    this.originalRef,
    name,
    Uint8List image,
    this.currentContext,
    this.UUID,
    this.topLeftCorner,
    this.bottomRightCorner,
    this.prototypeNode,
    this.size,
  }) : super(
          topLeftCorner,
          bottomRightCorner,
          currentContext,
          name,
          UUID: UUID ?? '',
        ) {
    generator = PBBitmapGenerator();

    ImageReferenceStorage().addReferenceAndWrite(
        UUID, '${MainInfo().outputPath}assets/images', image);
  }

<<<<<<< HEAD
=======
  @override
  void addChild(PBIntermediateNode node) {
    // Hopefully we converted the SVG correctly. Most likely this will get called to add the shapes but this is unnecessary.
    if (node is InheritedShapePath) {
      return;
    }
    assert(false,
        'Child with type ${node.runtimeType} could not be added as a child.');
    return;
  }

  @override
  void alignChild() {
    // Images don't have children.
  }

  static PBIntermediateNode fromJson(Map<String, dynamic> json) =>
      _$InheritedStarFromJson(json)
        ..topLeftCorner = Point.topLeftFromJson(json)
        ..bottomRightCorner = Point.bottomRightFromJson(json)
        ..originalRef = json;

  @override
  PBIntermediateNode createIntermediateNode(Map<String, dynamic> json) =>
      InheritedStar.fromJson(json);
>>>>>>> origin/feat/pbdl-interpret
}
