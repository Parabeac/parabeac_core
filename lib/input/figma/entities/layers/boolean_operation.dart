import 'package:json_annotation/json_annotation.dart';
import 'package:parabeac_core/design_logic/group_node.dart';
import 'package:parabeac_core/input/figma/entities/abstract_figma_node_factory.dart';
import 'package:parabeac_core/input/figma/entities/layers/vector.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_context.dart';

import 'figma_node.dart';

part 'boolean_operation.g.dart';

@JsonSerializable(nullable: true)
class BooleanOperation extends FigmaVector
    implements FigmaNodeFactory, GroupNode {
  @override
  List children;
  String booleanOperation;

  @override
  String type = 'BOOLEAN_OPERATION';

  BooleanOperation({List<FigmaNode> this.children});

  @override
  FigmaNode createFigmaNode(Map<String, dynamic> json) =>
      BooleanOperation.fromJson(json);
  factory BooleanOperation.fromJson(Map<String, dynamic> json) =>
      _$BooleanOperationFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$BooleanOperationToJson(this);

  @override
  Future<PBIntermediateNode> interpretNode(PBContext currentContext) {
    //TODO: implement
    return null;
  }
}
