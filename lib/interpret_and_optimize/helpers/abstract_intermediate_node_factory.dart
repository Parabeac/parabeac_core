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
import 'package:parabeac_core/interpret_and_optimize/entities/layouts/column.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/layouts/group/base_group.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/layouts/group/frame_group.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/layouts/group/group.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/pb_shared_instance.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/pb_shared_master_node.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_intermediate_node_tree.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_plugin_list_helper.dart';
import 'package:parabeac_core/tags/custom_tag/custom_tag.dart';

class AbstractIntermediateNodeFactory {
  static final String INTERMEDIATE_TYPE = 'type';

  static final Set<IntermediateNodeFactory> _intermediateNodes = {
    InheritedBitmap('$InheritedBitmap', null),
    InheritedCircle('$InheritedCircle', null),
    InheritedContainer('$InheritedContainer', null),
    InheritedOval('$InheritedOval', null),
    InheritedPolygon('$InheritedPolygon', null),
    InheritedScaffold('$InheritedScaffold', null, null, null),
    InheritedShapeGroup('$InheritedShapeGroup', null),
    InheritedShapePath('$InheritedShapePath', null),
    InheritedStar('$InheritedStar', null),
    InheritedText('$InheritedText', null),
    InheritedTriangle('$InheritedTriangle', null),
    PBSharedInstanceIntermediateNode('$PBSharedInstanceIntermediateNode', null),
    PBSharedMasterNode('$PBSharedMasterNode', null),
    BaseGroup('$Group', null),
    FrameGroup('$FrameGroup', null),
    PBIntermediateColumnLayout(null),
  };

  AbstractIntermediateNodeFactory();

  static dynamic getIntermediateNode(Map<String, dynamic> json,
      PBIntermediateNode parent, PBIntermediateTree tree) {
    var className = json[INTERMEDIATE_TYPE];
    if (className != null && (json['isVisible'] ?? true)) {
      for (var candidate in _intermediateNodes) {
        if (candidate.type == className) {
          var iNode = candidate.createIntermediateNode(json, parent, tree);

          var tag =
              PBPluginListHelper().returnAllowListNodeIfExists(iNode, tree);
          // Return tag if it exists
          if (tag != null) {
            /// TODO: Each Tag could potentially implement how it should handle converting from PBIntermediate to a PBTag
            if (tag is CustomTag) {
              return tag.handleIntermediateNode(iNode, parent, tag, tree);
            } else {
              //  [iNode] needs a parent and has not been added to the [tree] by [tree.addEdges]
              iNode.parent = parent;
              tree.replaceNode(iNode, tag, acceptChildren: true);

              return tag;
            }
          }
          if (parent != null && iNode != null) {
            tree.addEdges(parent, [iNode]);
          }

          return iNode;
        }
      }
    }
    return null;
  }
}

abstract class IntermediateNodeFactory {
  String type;
  PBIntermediateNode createIntermediateNode(Map<String, dynamic> json,
      PBIntermediateNode parent, PBIntermediateTree tree);
}
