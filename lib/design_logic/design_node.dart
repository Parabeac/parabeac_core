import 'package:parabeac_core/design_logic/pb_style.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_context.dart';

import 'abstract_design_node_factory.dart';

class DesignNode {
  DesignNode(
    this.UUID,
    this.name,
    this.isVisible,
    this.boundaryRectangle,
    this.type,
    this.style,
    this.prototypeNodeUUID,
  );

  String pbdfType;
  String UUID;
  String name;
  bool isVisible;
  var boundaryRectangle;
  String type;
  PBStyle style;
  String prototypeNodeUUID;

  toJson() {}

  Future<PBIntermediateNode> interpretNode(PBContext currentContext) {}

  Map<String, dynamic> toPBDF() {}

  factory DesignNode.fromPBDF(Map<String, dynamic> json) =>
      AbstractDesignNodeFactory.getDesignNode(json);

  factory DesignNode.fromJson(Map<String, dynamic> json) =>
      AbstractDesignNodeFactory.getDesignNode(json);
}
