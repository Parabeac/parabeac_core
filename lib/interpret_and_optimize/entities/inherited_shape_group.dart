import 'dart:math';
import 'dart:typed_data';
import 'package:parabeac_core/controllers/main_info.dart';
import 'package:parabeac_core/generation/generators/visual-widgets/pb_bitmap_gen.dart';
import 'package:parabeac_core/generation/prototyping/pb_prototype_node.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/interfaces/pb_inherited_intermediate.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_constraints.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_visual_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/align_strategy.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/child_strategy.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_context.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_image_reference_storage.dart';

import 'package:parabeac_core/interpret_and_optimize/helpers/abstract_intermediate_node_factory.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_context.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_image_reference_storage.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_intermediate_node_tree.dart';
import 'package:parabeac_core/interpret_and_optimize/state_management/intermediate_auxillary_data.dart';
import 'package:path/path.dart' as p;
part 'inherited_shape_group.g.dart';

@JsonSerializable()
class InheritedShapeGroup extends PBVisualIntermediateNode
    implements PBInheritedIntermediate, IntermediateNodeFactory {
  @override
  @JsonKey(
      fromJson: PrototypeNode.prototypeNodeFromJson, name: 'prototypeNodeUUID')
  PrototypeNode prototypeNode;

  @override
  @JsonKey()
  String type = 'image';

  @override
  @JsonKey(ignore: true)
  Map<String, dynamic> originalRef;

  InheritedShapeGroup(
    String UUID,
    Rectangle3D frame, {
    this.originalRef,
    String name,
    Uint8List image,
    this.prototypeNode,
    PBIntermediateConstraints constraints,
  }) : super(UUID, frame, name, constraints: constraints) {
    generator = PBBitmapGenerator();
    childrenStrategy = NoChildStrategy();

    ImageReferenceStorage().addReferenceAndWrite(
        UUID, p.join(MainInfo().outputPath, 'assets/images'), image);
  }

  static PBIntermediateNode fromJson(Map<String, dynamic> json) {
    var group = _$InheritedShapeGroupFromJson(json)..originalRef = json;

    // group.mapRawChildren(json);

    return group;
  }

  @override
  PBIntermediateNode createIntermediateNode(Map<String, dynamic> json,
          PBIntermediateNode parent, PBIntermediateTree tree) =>
      InheritedShapeGroup.fromJson(json)..mapRawChildren(json, tree);
}
