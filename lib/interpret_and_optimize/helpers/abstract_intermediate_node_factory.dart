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
import 'package:parabeac_core/interpret_and_optimize/entities/injected_container.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/layouts/temp_group_layout_node.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/pb_shared_instance.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/pb_shared_master_node.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_intermediate_node_tree.dart';

class AbstractIntermediateNodeFactory {
  static final String INTERMEDIATE_TYPE = 'type';

  static final List<IntermediateNodeFactory> _figmaNodes = [
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
    InjectedContainer(),
    PBSharedInstanceIntermediateNode(),
    PBSharedMasterNode(),
    TempGroupLayoutNode(),
    PBIntermediateTree(),
  ];

  AbstractIntermediateNodeFactory();

  static PBIntermediateNode getFigmaNode(Map<String, dynamic> json) {
    var className = json[INTERMEDIATE_TYPE];
    if (className != null) {
      for (var intermediateNode in _figmaNodes) {
        if (intermediateNode.type == className) {
          return intermediateNode.fromJson(json);
        }
      }
    }
    return null;
  }
}

abstract class IntermediateNodeFactory {
  String type;
  PBIntermediateNode fromJson(Map<String, dynamic> json);
}
