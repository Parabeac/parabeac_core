import 'package:parabeac_core/generation/generators/plugins/pb_plugin_node.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/pb_shared_master_node.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_constraints.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/child_strategy.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_intermediate_node_tree.dart';
import 'package:parabeac_core/interpret_and_optimize/state_management/intermediate_auxillary_data.dart';
import 'package:parabeac_core/tags/custom_text_form_field/custom_text_form_field_generator.dart';
import 'package:recase/recase.dart';

class CustomTextFormField extends PBTag {
  @override
  final String semanticName = '<textformfield>';
  CustomTextFormField(
    String UUID,
    Rectangle3D frame,
    String name,
    PBIntermediateConstraints constraints, {
    IntermediateAuxiliaryData auxiliaryData,
  }) : super(
          UUID,
          frame,
          name,
          auxiliaryData: auxiliaryData,
          contraints: constraints,
        ) {
    generator = CustomTextFormFieldGenerator();
    childrenStrategy = MultipleChildStrategy('children');
  }

  @override
  PBIntermediateNode handleIntermediateNode(PBIntermediateNode iNode,
      PBIntermediateNode parent, PBTag tag, PBIntermediateTree tree) {
    /// Need to remove auxiliary data from component so it's not duplicated
    if (iNode is PBSharedMasterNode) {
      iNode.auxiliaryData = IntermediateAuxiliaryData();
    }
    return super.handleIntermediateNode(iNode, parent, tag, tree);
  }

  @override
  void extractInformation(PBIntermediateNode incomingNode) {
    // TODO: implement extractInformation
  }

  @override
  PBTag generatePluginNode(Rectangle3D frame, PBIntermediateNode originalRef,
      PBIntermediateTree tree) {
    return CustomTextFormField(
      null,
      frame.copyWith(),
      originalRef.name.replaceAll(semanticName, '').pascalCase,
      originalRef.constraints.copyWith(),
      auxiliaryData: originalRef.auxiliaryData.copyWith(),
    );
  }
}
