import 'package:parabeac_core/generation/prototyping/pb_prototype_node.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/injected_container.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/intermediate_border_info.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/layouts/group/group.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/layouts/rules/layout_rule.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/layouts/exceptions/layout_exception.dart';
import 'dart:math';

import 'package:json_annotation/json_annotation.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_constraints.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_layout_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_color.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_context.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_intermediate_node_tree.dart';
import 'package:parabeac_core/interpret_and_optimize/state_management/intermediate_auxillary_data.dart';

part 'frame_group.g.dart';

@JsonSerializable(ignoreUnannotated: true, createToJson: true)

/// When creating [FrameGroup]s that is not from JSON (In other words, its being injected rather than inherited)
/// the values for the [PBIntermediateConstraints] are going to be [PBIntermediateConstraints.defaultConstraints()].
/// Furthermore, the [frame] is going to be as big as it could be if the [FrameGroup] was injected rather than derived
/// from the JSON file.
class FrameGroup extends Group {
  @override
  @JsonKey()
  String type = 'frame';

  FrameGroup(String UUID, Rectangle3D<num> frame,
      {String name,
      PrototypeNode prototypeNode,
      PBIntermediateConstraints constraints})
      : super(UUID, frame,
            name: name, prototypeNode: prototypeNode, constraints: constraints);

  @override
  PBIntermediateNode createIntermediateNode(Map<String, dynamic> json,
      PBIntermediateNode parent, PBIntermediateTree tree) {
    var tempFrame = _$FrameGroupFromJson(json)..originalRef = json;

    var tempChild = injectAContainer(json, tempFrame.frame);

    if (tempChild != null) {
      tree.addEdges(tempFrame, [tempChild]);
    }
    return tempFrame..mapRawChildren(json, tree);
  }

  PBIntermediateNode injectAContainer(
      Map<String, dynamic> json, Rectangle3D parentFrame) {
    var tempChild = InjectedContainer(
      null,
      parentFrame..z = 0,
      name: json['name'],
    );
    var gateKeeper = false;
    if (json['fixedRadius'] != null) {
      tempChild.auxiliaryData.borderInfo =
          IntermediateBorderInfo(borderRadius: json['fixedRadius']);
      tempChild.auxiliaryData.borderInfo.isBorderOutlineVisible = true;
      gateKeeper = true;
    }
    if (json['background'] != null) {
      tempChild.auxiliaryData.color = PBColor.fromJson(json['background']);
      gateKeeper = true;
    }
    if (json['style']['borders'][0]['isEnabled']) {
      tempChild.auxiliaryData.borderInfo ??= IntermediateBorderInfo();
      tempChild.auxiliaryData.borderInfo.isBorderOutlineVisible = true;
      tempChild.auxiliaryData.borderInfo.color =
          PBColor.fromJson(json['style']['borders'][0]['color']);
      tempChild.auxiliaryData.borderInfo.thickness =
          json['style']['borders'][0]['thickness'];
      gateKeeper = true;
    }

    return gateKeeper ? tempChild : null;
  }
}
