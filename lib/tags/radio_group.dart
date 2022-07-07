// ignore_for_file: unused_local_variable

import 'package:parabeac_core/generation/generators/pb_generator.dart';
import 'package:parabeac_core/generation/generators/plugins/pb_plugin_node.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/inherited_text.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/pb_shared_instance.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_constraints.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_context.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_intermediate_node_tree.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_symbol_storage.dart';
import 'package:recase/recase.dart';

class RadioGroupCustom extends PBTag {
  @override
  String semanticName = '<radiogroup>';
  RadioGroupCustom(
    String UUID,
    Rectangle3D<num> frame,
    String name, {
    PBIntermediateConstraints constraints,
  }) : super(
          UUID,
          frame,
          name,
          contraints: constraints,
        ) {
    generator = RadioGroupGenerator();
  }

  @override
  void extractInformation(PBIntermediateNode incomingNode) {}

  @override
  PBTag generatePluginNode(Rectangle3D<num> frame,
      PBIntermediateNode originalNode, PBIntermediateTree tree) {
    return RadioGroupCustom(
      null,
      frame.copyWith(),
      originalNode.name.replaceAll(semanticName, '').pascalCase,
      constraints: originalNode.constraints.copyWith(),
    );
  }
}

class RadioGroupGenerator extends PBGenerator {
  String groupName;
  final String buttonSemantic = '<radiobutton>';
  final String choiceSemantic = '<choice>';

  final List<String> enumVals = [];
  final List<String> titles = [];
  @override
  String generate(PBIntermediateNode source, PBContext context) {
    groupName = source.name.pascalCase;
    var buttons = context.tree
        .where((element) => element.name?.contains(buttonSemantic) ?? false)
        .cast<PBIntermediateNode>();
    gatherButtoninfo(buttons, context);

    var enumStr = generateEnum(
        groupName, buttons.map((e) => e.name.replaceAll(buttonSemantic, '')));

    return '';
  }

  void gatherButtoninfo(Iterable<PBIntermediateNode> nodes, PBContext context) {
    nodes.forEach((element) {
      element.name = element.name.replaceAll(buttonSemantic, '');
      enumVals.add(element.name.camelCase);
      if (element is PBSharedInstanceIntermediateNode) {
      } else {
        InheritedText text = context.tree.firstWhere(
            (element) =>
                element.name.contains(choiceSemantic) &&
                element is InheritedText,
            orElse: () =>
                throw Exception('No text found for Radio ${element.name}'));

        titles.add(text.text);
      }
    });
  }

  String generateEnum(String name, Iterable<String> values) {
    return '''
enum $name {
${values.map((e) => '  $e,').join('\n')}
}
    ''';
  }

  String generateListTile(String title, String value) {
    return '''
ListTile(
  title: Text(\'$title\'),
  leading: Radio<$groupName>(
    value: $value,
    groupValue: ${groupName.camelCase}Logic.getGroupvalue(context),
    onChanged: ${groupName.camelCase}Logic.onChanged(newValue: newValue, context: context, setState: setState,),
  ),
),
    ''';
  }
}
