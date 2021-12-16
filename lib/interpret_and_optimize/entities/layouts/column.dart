import 'package:parabeac_core/generation/generators/layouts/pb_column_gen.dart';
import 'package:parabeac_core/generation/prototyping/pb_prototype_node.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/layouts/exceptions/layout_exception.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/layouts/exceptions/stack_exception.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/layouts/rules/axis_comparison_rules.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/layouts/rules/layout_rule.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_constraints.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_layout_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/abstract_intermediate_node_factory.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/align_strategy.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_context.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_intermediate_node_tree.dart';
import 'package:parabeac_core/interpret_and_optimize/state_management/intermediate_auxillary_data.dart';
import 'auto_layout_align_strategy.dart';
import 'layout_properties.dart';
import 'package:json_annotation/json_annotation.dart';

part 'column.g.dart';

@JsonSerializable(createToJson: true)

///Colum contains nodes that are all `vertical` to each other, without overlapping eachother
class PBIntermediateColumnLayout extends PBLayoutIntermediateNode
    implements IntermediateNodeFactory {
  static final List<LayoutRule> COLUMN_RULES = [
    VerticalNodesLayoutRule(),
  ];

  static final List<LayoutException> COLUMN_EXCEPTIONS = [
    ColumnOverlappingException(),
  ];

  @override
  AlignStrategy alignStrategy = AutoLayoutAlignStrategy();

  PBIntermediateColumnLayout(Rectangle3D frame, {String name})
      : super(null, frame, COLUMN_RULES, COLUMN_EXCEPTIONS, name) {
    generator = PBColumnGenerator();
  }

  @override
  PBLayoutIntermediateNode generateLayout(List<PBIntermediateNode> children,
      PBContext currentContext, String name) {
    // TODO: fix this method
    var col = PBIntermediateColumnLayout(null, name: name);
    col.prototypeNode = prototypeNode;
    //FIXME children.forEach((child) => col.addChild(child));

    return col;
  }

  @JsonKey(name: 'autoLayoutOptions')
  LayoutProperties layoutProperties;

  @override
  String type = 'col';

  @override
  PBIntermediateNode createIntermediateNode(Map<String, dynamic> json,
      PBIntermediateNode parent, PBIntermediateTree tree) {
    var tempCol = _$PBIntermediateColumnLayoutFromJson(json)
      ..mapRawChildren(json, tree);
    return tempCol;
  }
}
