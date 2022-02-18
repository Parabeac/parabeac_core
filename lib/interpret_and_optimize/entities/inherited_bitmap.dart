import 'package:parabeac_core/controllers/main_info.dart';
import 'package:parabeac_core/generation/generators/util/pb_input_formatter.dart';
import 'package:parabeac_core/generation/generators/visual-widgets/pb_bitmap_gen.dart';
import 'package:parabeac_core/generation/prototyping/pb_prototype_node.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/interfaces/pb_inherited_intermediate.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_constraints.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_visual_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/child_strategy.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/abstract_intermediate_node_factory.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_image_reference_storage.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_intermediate_node_tree.dart';
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

  @JsonKey(name: 'imageReference')
  String referenceImage;

  @override
  @JsonKey()
  String type = 'image';

  @override
  @JsonKey(ignore: true)
  Map<String, dynamic> originalRef;

  InheritedBitmap(
    String UUID,
    Rectangle3D frame, {
    this.originalRef,
    String name,
    this.referenceImage,
    this.prototypeNode,
    PBIntermediateConstraints constraints,
  }) : super(UUID, frame, name, constraints: constraints) {
    generator = PBBitmapGenerator();
    childrenStrategy = NoChildStrategy();
    if (name != null && name.isNotEmpty) {
      ImageReferenceStorage()
          .addReference(name, '${MainInfo().outputPath}assets/images');
    }
  }

  static PBIntermediateNode fromJson(Map<String, dynamic> json) =>
      _$InheritedBitmapFromJson(json)
        // . .frame.topLeft = Point.topLeftFromJson(json)
        // . .frame.bottomRight = Point.bottomRightFromJson(json)
        ..originalRef = json;

  @override
  PBIntermediateNode createIntermediateNode(Map<String, dynamic> json,
          PBIntermediateNode parent, PBIntermediateTree tree) =>
      (InheritedBitmap.fromJson(json) as InheritedBitmap)..originalRef = json;
}
