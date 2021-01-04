import 'package:parabeac_core/generation/generators/pb_generation_manager.dart';
import 'package:parabeac_core/generation/generators/util/pb_input_formatter.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';

abstract class TemplateStrategy {
  String generateTemplate(PBIntermediateNode node, PBGenerationManager manager,
      {var args});
  String retrieveNodeName(var node) {
    var formatter = (name) => PBInputFormatter.formatLabel(name,
        isTitle: true, space_to_underscore: false);
    var widgetName;
    if (node is PBIntermediateNode) {
      widgetName = formatter(node.name);
    } else if (node is String) {
      widgetName = formatter(node);
    } else {
      widgetName = node;
    }
    return widgetName;
  }
}

///Generating a [StatefulWidget]
class StatefulTemplateStrategy extends TemplateStrategy {
  @override
  String generateTemplate(PBIntermediateNode node, PBGenerationManager manager,
      {args}) {
    var widgetName = retrieveNodeName(node);
    var constructorName = '$widgetName';
    var returnStatement = manager.generate(node?.child);
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
    ${manager.methodVariableStr}
    return ${returnStatement};
  }
}''';
  }
}

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

class InlineTemplateStrategy extends TemplateStrategy {
  @override
  String generateTemplate(PBIntermediateNode node, PBGenerationManager manager,
      {var args}) {
    return node is String ? node : node.generator.generate(node);
  }
}

class EmptyPageTemplateStrategy extends TemplateStrategy {
  @override
  String generateTemplate(PBIntermediateNode node, PBGenerationManager manager,
          {var args}) =>
      args is String ? args : '';
}
