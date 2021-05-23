import 'package:parabeac_core/generation/generators/attribute-helper/pb_generator_context.dart';
import 'package:parabeac_core/generation/generators/pb_generation_manager.dart';
import 'package:parabeac_core/generation/generators/value_objects/template_strategy/pb_template_strategy.dart';
import 'package:parabeac_core/input/sketch/helper/symbol_node_mixin.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/pb_shared_master_node.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:recase/recase.dart';

class BLoCStateTemplateStrategy extends TemplateStrategy {
  bool isFirst = true;
  String abstractClassName;
  BLoCStateTemplateStrategy({this.isFirst, this.abstractClassName});
  @override
  String generateTemplate(PBIntermediateNode node, PBGenerationManager manager,
      GeneratorContext generatorContext,
      {args}) {
    var widgetName = retrieveNodeName(node);
    node.managerData.hasParams = true;
    var returnStatement = node.generator.generate(node, generatorContext);
    node.managerData.hasParams = false;
    var overrides = '';
    var overrideVars = '';
    if (node is PBSharedMasterNode && node.overridableProperties.isNotEmpty) {
      node.overridableProperties.forEach((prop) {
        overrides += '${prop.friendlyName}, ';
        overrideVars += 'var ${prop.friendlyName};';
      });
    }

    return '''
${isFirst ? _getHeader(manager) : ''}

class ${node.name.pascalCase}State extends ${abstractClassName.pascalCase}State{
  ${manager.generateGlobalVariables()}

  ${overrideVars}
  

  ${widgetName + 'State'}(${(overrides.isNotEmpty ? '{$overrides}' : '')}){}

  @override
  Widget get widget => ${returnStatement};

}''';
  }

  String _getHeader(manager) {
    return '''
    part of '${abstractClassName.snakeCase}_bloc.dart';

    @immutable
    abstract class ${abstractClassName.pascalCase}State{
      Widget get widget;
    }
    ''';
  }
}
