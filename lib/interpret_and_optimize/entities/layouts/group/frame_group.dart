import 'package:get_it/get_it.dart';
import 'package:parabeac_core/analytics/amplitude_analytics_service.dart';
import 'package:parabeac_core/generation/prototyping/pb_prototype_node.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/interfaces/pb_inherited_intermediate.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/layouts/group/group.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_constraints.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/abstract_intermediate_node_factory.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_intermediate_node_tree.dart';
import 'package:parabeac_core/interpret_and_optimize/state_management/intermediate_auxillary_data.dart';

part 'frame_group.g.dart';

@JsonSerializable(ignoreUnannotated: true, createToJson: true)

/// When creating [FrameGroup]s that is not from JSON (In other words, its being injected rather than inherited)
/// the values for the [PBIntermediateConstraints] are going to be [PBIntermediateConstraints.defaultConstraints()].
/// Furthermore, the [frame] is going to be as big as it could be if the [FrameGroup] was injected rather than derived
/// from the JSON file.
class FrameGroup extends Group
    implements PBInheritedIntermediate, IntermediateNodeFactory {
  @override
  @JsonKey()
  String type = 'frame';

  FrameGroup(
    String UUID,
    Rectangle3D<num> frame, {
    String name,
    PrototypeNode prototypeNode,
    PBIntermediateConstraints constraints,
  }) : super(UUID, frame,
            name: name, prototypeNode: prototypeNode, constraints: constraints);

  @override
  PBIntermediateNode createIntermediateNode(Map<String, dynamic> json,
      PBIntermediateNode parent, PBIntermediateTree tree) {
    // Add number of Frame groups to analytics
    if (!tree.lockData) {
      GetIt.I.get<AmplitudeService>().addToAnalytics('Number of frames');
    }
    var tempFrame = _$FrameGroupFromJson(json);
    return tempFrame
      ..mapRawChildren(json, tree)
      ..originalRef = json;
  }
}
