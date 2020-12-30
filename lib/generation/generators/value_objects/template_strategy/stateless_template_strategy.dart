import 'package:parabeac_core/generation/generators/pb_generation_manager.dart';
import 'package:parabeac_core/generation/generators/value_objects/template_strategy/pb_template_strategy.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/inherited_scaffold.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:recase/recase.dart';

class StatelessTemplateStrategy extends TemplateStrategy {
  @override
  String generateTemplate(PBIntermediateNode node, PBGenerationManager manager,
      {args}) {
    var widgetName = retrieveNodeName(node);
    var returnStatement = node.generator.generate(node);
    return '''
${manager.generateImports()}

class ${widgetName.pascalCase} extends StatelessWidget{
  const ${widgetName.pascalCase}({Key key}) : super(key : key);
  ${manager.generateGlobalVariables()}

  @override
  Widget build(BuildContext context){
    return ${returnStatement};
  }
}''';
  }
}
