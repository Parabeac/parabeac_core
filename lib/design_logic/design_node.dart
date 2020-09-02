import 'package:json_annotation/json_annotation.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_context.dart';

part 'design_node.g.dart';

@JsonSerializable()
abstract class DesignNode {
  DesignNode(
    this.UUID,
    this.name,
    this.isVisible,
    this.boundaryRectangle,
    this.type,
    this.style,
  );

  String UUID;
  String name;
  bool isVisible;
  var boundaryRectangle;
  String type;
  var style;

  factory DesignNode.fromJson(Map<String, dynamic> json) =>
      _$DesignNodeFromJson(json);
  Map<String, dynamic> toJson() => _$DesignNodeToJson(this);
  Future<PBIntermediateNode> interpretNode(PBContext currentContext);
}
