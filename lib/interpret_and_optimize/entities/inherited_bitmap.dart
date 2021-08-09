import 'dart:math';

import 'package:parabeac_core/controllers/main_info.dart';
import 'package:parabeac_core/generation/generators/visual-widgets/pb_bitmap_gen.dart';
import 'package:parabeac_core/generation/prototyping/pb_prototype_node.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/interfaces/pb_inherited_intermediate.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_constraints.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_visual_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/align_strategy.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/child_strategy.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/abstract_intermediate_node_factory.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_context.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_image_reference_storage.dart';
// import 'dart:math';
import 'package:quick_log/quick_log.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:parabeac_core/interpret_and_optimize/state_management/intermediate_auxillary_data.dart';

part 'inherited_bitmap.g.dart';

@JsonSerializable()
class InheritedBitmap extends PBVisualIntermediateNode
    implements PBInheritedIntermediate, IntermediateNodeFactory {
  @override
  @JsonKey(
      fromJson: PrototypeNode.prototypeNodeFromJson, name: 'prototypeNodeUUID')
  PrototypeNode prototypeNode;

  @override
  ChildrenStrategy childrenStrategy = NoChildStrategy();


  @JsonKey(name: 'imageReference')
  String referenceImage;

  @override
  @JsonKey()
  String type = 'image';

  @override
  @JsonKey(ignore: true)
  Point topLeftCorner;
  @override
  @JsonKey(ignore: true)
  Point bottomRightCorner;

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

  InheritedBitmap({
    this.originalRef,
    String name,
    this.currentContext,
    this.referenceImage,
    this.bottomRightCorner,
    this.topLeftCorner,
    this.UUID,
    this.prototypeNode,
    this.size,
  }) : super(topLeftCorner, bottomRightCorner, currentContext, name,
            UUID: UUID ?? '') {
    generator = PBBitmapGenerator();
    ImageReferenceStorage()
        .addReference(UUID, '${MainInfo().outputPath}assets/images');
  }

  static PBIntermediateNode fromJson(Map<String, dynamic> json) =>
      _$InheritedBitmapFromJson(json)
        ..topLeftCorner = Point.topLeftFromJson(json)
        ..bottomRightCorner = Point.bottomRightFromJson(json)
        ..originalRef = json;

  @override
  PBIntermediateNode createIntermediateNode(Map<String, dynamic> json) =>
      (InheritedBitmap.fromJson(json) as InheritedBitmap)..originalRef = json;
}
