import 'package:parabeac_core/design_logic/design_node.dart';
import 'package:parabeac_core/design_logic/pb_style.dart';
import 'package:parabeac_core/input/sketch/entities/objects/frame.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_context.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';

import 'abstract_design_node_factory.dart';

class BooleanOperation implements DesignNodeFactory, DesignNode {
  @override
  String pbdfType = 'boolean_operation';

  List<DesignNode> children = [];

  @override
  var boundaryRectangle;

  BooleanOperation({
    booleanOperation,
    type,
    Frame this.boundaryRectangle,
    String UUID,
    String name,
    bool isVisible,
    pbdfType,
  });

  @override
  DesignNode createDesignNode(Map<String, dynamic> json) => fromPBDF(json);

  DesignNode fromPBDF(Map<String, dynamic> json) {
    var node = BooleanOperation(
      booleanOperation: json['booleanOperation'],
      type: json['type'],
      boundaryRectangle: json['absoluteBoundingBox'] == null
          ? null
          : Frame.fromJson(json['absoluteBoundingBox'] as Map<String, dynamic>),
      UUID: json['id'] as String,
      name: json['name'] as String,
      isVisible: json['visible'] as bool ?? true,
      pbdfType: json['pbdfType'] as String,
    );
    if (json.containsKey('children')) {
      if (json['children'] != null) {
        node.children
            .add(DesignNode.fromPBDF(json['children'] as Map<String, dynamic>));
      }
    }
    return node;
  }

  @override
  String UUID;

  @override
  String name;

  @override
  String prototypeNodeUUID;

  @override
  PBStyle style;

  @override
  String type;

  @override
  Future<PBIntermediateNode> interpretNode(PBContext currentContext) {
    // TODO: implement interpretNode
    throw UnimplementedError();
  }

  @override
  toJson() {
    // TODO: implement toJson
    throw UnimplementedError();
  }

  @override
  Map<String, dynamic> toPBDF() {
    // TODO: implement toPBDF
    throw UnimplementedError();
  }

  @override
  bool isVisible;
}
