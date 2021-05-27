import 'package:parabeac_core/generation/generators/attribute-helper/pb_generator_context.dart';
import 'package:parabeac_core/generation/generators/pb_generation_manager.dart';
import 'package:parabeac_core/generation/generators/value_objects/template_strategy/pb_template_strategy.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/pb_shared_master_node.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';

///Generating a [StatefulWidget]
class StatefulTemplateStrategy extends TemplateStrategy {
  @override
  String generateTemplate(PBIntermediateNode node, PBGenerationManager manager,
      GeneratorContext generatorContext,
      {args}) {
    var widgetName = retrieveNodeName(node);
    var constructorName = '$widgetName';
    var returnStatement = node.generator.generate(node, generatorContext);

    return '''
${manager.generateImports()}

class ${widgetName} extends StatefulWidget{
  const ${widgetName}() : super();
  @override
  _${widgetName} createState() => _${widgetName}();
}

class _${widgetName} extends State<${widgetName}>{
  ${manager.generateGlobalVariables()}
  _${manager.generateConstructor(constructorName)}

  @override
  Widget build(BuildContext context){
    ${manager.data.methodVariableStr}
    return ${returnStatement};
  }

  ${manager.generateDispose()}
}

''';
  }
}
