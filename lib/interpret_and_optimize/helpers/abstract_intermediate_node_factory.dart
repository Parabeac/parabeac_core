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
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_intermediate_node_tree.dart';

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
      for (var intermediateNode in _intermediateNodes) {
        if (intermediateNode.type == className) {
          return intermediateNode.createIntermediateNode(json);
        }
      }
    }
    return null;
  }
}

abstract class IntermediateNodeFactory {
  String type;
  dynamic createIntermediateNode(Map<String, dynamic> json);
}
