import 'package:parabeac_core/generation/generators/pb_generation_manager.dart';
import 'package:parabeac_core/generation/generators/value_objects/template_strategy/pb_template_strategy.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/pb_shared_master_node.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_context.dart';
import 'package:recase/recase.dart';

class StatelessTemplateStrategy extends TemplateStrategy {
  @override
  String generateTemplate(
      PBIntermediateNode node, PBGenerationManager manager, PBContext context,
      {args}) {
    var widgetName = node.name;
    context.managerData.hasParams = true;
    var returnStatement = node.generator.generate(node, context);
    context.managerData.hasParams = false;
    var overrides = '';
    var overrideVars = '';

    if (node is PBSharedMasterNode && node.overridableProperties.isNotEmpty) {
      node.overridableProperties.forEach((prop) {
        overrides += 'this.${prop.propertyName}, ';
        overrideVars += 'final ${prop.propertyName};';
      });
    }
    return '''
  ${manager.generateImports()}

class ${widgetName.pascalCase} extends StatelessWidget{
  ${node is PBSharedMasterNode ? 'final constraints;' : ''}
  ${overrideVars.isNotEmpty ? overrideVars : ''}
  ${widgetName.pascalCase}(${node is PBSharedMasterNode ? 'this.constraints,' : ''} {Key key, ${overrides.isNotEmpty ? overrides : ''}}) : super(key : key);
  ${manager.generateGlobalVariables()}

  @override
  Widget build(BuildContext context){
    return $returnStatement;
  }
}''';
  }
}
