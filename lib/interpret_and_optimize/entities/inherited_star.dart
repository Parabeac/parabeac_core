import 'dart:typed_data';
import 'package:parabeac_core/controllers/main_info.dart';
import 'package:parabeac_core/generation/generators/visual-widgets/pb_bitmap_gen.dart';
import 'package:parabeac_core/generation/prototyping/pb_prototype_node.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/inherited_shape_path.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/interfaces/pb_inherited_intermediate.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_visual_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/abstract_intermediate_node_factory.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_context.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_image_reference_storage.dart';
import 'package:parabeac_core/interpret_and_optimize/value_objects/point.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:parabeac_core/interpret_and_optimize/state_management/intermediate_auxillary_data.dart';

part 'inherited_star.g.dart';

@JsonSerializable()
class InheritedStar extends PBVisualIntermediateNode
    implements PBInheritedIntermediate, IntermediateNodeFactory {
  @override
  @JsonKey(
      fromJson: PrototypeNode.prototypeNodeFromJson, name: 'prototypeNodeUUID')
  PrototypeNode prototypeNode;

  @override
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
}
