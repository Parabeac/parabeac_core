import 'package:parabeac_core/generation/generators/layouts/pb_row_gen.dart';
import 'package:parabeac_core/generation/prototyping/pb_prototype_node.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/alignments/padding.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/layouts/exceptions/layout_exception.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/layouts/exceptions/stack_exception.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/layouts/rules/axis_comparison_rules.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/layouts/rules/handle_flex.dart';
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

part 'row.g.dart';

@JsonSerializable(createToJson: true)

///Row contains nodes that are all `horizontal` to each other, without overlapping eachother

class PBIntermediateRowLayout extends PBLayoutIntermediateNode
    implements IntermediateNodeFactory {
  static final List<LayoutRule> ROW_RULES = [HorizontalNodesLayoutRule()];

  static final List<LayoutException> ROW_EXCEPTIONS = [
    RowOverlappingException()
  ];

  @override
  PrototypeNode prototypeNode;

  @override
  AlignStrategy alignStrategy = AutoLayoutAlignStrategy();

  PBIntermediateRowLayout({String name})
      : super(null, null, ROW_RULES, ROW_EXCEPTIONS, name) {
    generator = PBRowGenerator();
  }

  @override
  PBLayoutIntermediateNode generateLayout(List<PBIntermediateNode> children,
      PBContext currentContext, String name) {
    var row = PBIntermediateRowLayout(name: name);
    row.prototypeNode = prototypeNode;
    //FIXME children.forEach((child) => row.addChild(child));
    return row;
  }

  @JsonKey(name: 'autoLayoutOptions')
  LayoutProperties layoutProperties;

  @override
  String type = 'row';

  @override
  PBIntermediateNode createIntermediateNode(Map<String, dynamic> json,
      PBIntermediateNode parent, PBIntermediateTree tree) {
    var tempRow = _$PBIntermediateRowLayoutFromJson(json)
      ..mapRawChildren(json, tree);
    return tempRow;
  }

  @override
  void sortChildren(List<PBIntermediateNode> children) {
    children.sort((child0, child1) =>
        child0.frame.topLeft.x.compareTo(child1.frame.topLeft.x));
  }
}
