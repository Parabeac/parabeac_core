import 'package:parabeac_core/design_logic/pb_style.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_context.dart';

abstract class DesignNode {
  DesignNode(
    this.UUID,
    this.name,
    this.isVisible,
    this.boundaryRectangle,
    this.type,
    this.style,
    this.prototypeNodeUUID,
  );

  String UUID;
  String name;
  bool isVisible;
  var boundaryRectangle;
  String type;
  PBStyle style;
  String prototypeNodeUUID;

  toJson();

  Future<PBIntermediateNode> interpretNode(PBContext currentContext);
}
