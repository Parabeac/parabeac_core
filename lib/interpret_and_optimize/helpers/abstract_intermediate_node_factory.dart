import 'package:parabeac_core/interpret_and_optimize/entities/inherited_bitmap.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/inherited_circle.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/inherited_container.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/inherited_oval.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/inherited_polygon.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/inherited_scaffold.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/inherited_shape_group.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/inherited_shape_path.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/inherited_star.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/inherited_text.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/inherited_triangle.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/layouts/temp_group_layout_node.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/pb_shared_instance.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/pb_shared_master_node.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_intermediate_node_tree.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_plugin_list_helper.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_state_management_helper.dart';

class AbstractIntermediateNodeFactory {
  static final String INTERMEDIATE_TYPE = 'type';

  static final Set<IntermediateNodeFactory> _intermediateNodes = {
    InheritedBitmap(),
    InheritedCircle(),
    InheritedContainer(),
    InheritedOval(),
    InheritedPolygon(),
    InheritedScaffold(),
    InheritedShapeGroup(),
    InheritedShapePath(),
    InheritedStar(),
    InheritedText(),
    InheritedTriangle(),
    PBSharedInstanceIntermediateNode(),
    PBSharedMasterNode(),
    TempGroupLayoutNode(),
    PBIntermediateTree(),
  };

  AbstractIntermediateNodeFactory();

  static dynamic getIntermediateNode(Map<String, dynamic> json) {
    var className = json[INTERMEDIATE_TYPE];
    if (className != null) {
      for (var candidate in _intermediateNodes) {
        if (candidate.type == className) {
          var iNode = candidate.createIntermediateNode(json);

          // Check if `iNode` is a tag
          var tag = PBPluginListHelper().returnAllowListNodeIfExists(iNode);
          // Return tag if it exists
          if (tag != null) {
            return tag;
          }
          return iNode;
        }
      }
    }
    return null;
  }

  /// Checks whether `node` is a state management node, and interprets it accordingly.
  ///
  /// Returns `null` if `node` is a non-default state management node, effectively removing `node` from the tree.
  /// Returns `node` if it is a default state management node or a non-state management node.
  static PBIntermediateNode interpretStateManagement(PBIntermediateNode node) {
    if (node is! PBSharedMasterNode) {
      return node;
    }
    var smHelper = PBStateManagementHelper();
    if (smHelper.isValidStateNode(node.name)) {
      if (smHelper.isDefaultNode(node)) {
        smHelper.interpretStateManagementNode(node);
        return node;
      } else {
        smHelper.interpretStateManagementNode(node);
        return null;
      }
    }
    return node;
  }
}

abstract class IntermediateNodeFactory {
  String type;
  dynamic createIntermediateNode(Map<String, dynamic> json);
}
