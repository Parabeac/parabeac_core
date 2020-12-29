import 'package:parabeac_core/generation/generators/pb_generation_manager.dart';
import 'package:parabeac_core/generation/generators/value_objects/template_strategy/pb_template_strategy.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';

class StatelessTemplateStrategy extends TemplateStrategy {
  @override
  String generateTemplate(PBIntermediateNode node, PBGenerationManager manager,
      {args}) {
    var widgetName = retrieveNodeName(node);
    var constructorName = '_$widgetName';
    var returnStatement = manager.generate(node.child);
    return '''
${manager.generateImports()}

class ${widgetName} extends StatelessWidget{
  const ${widgetName}({Key key}) : super(key : key);
  ${manager.generateGlobalVariables()}
  ${manager.generateConstructor(constructorName)}

  @override
  Widget build(BuildContext context){
    return ${returnStatement};
  }
}''';
  }
}
