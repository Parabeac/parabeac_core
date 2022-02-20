import 'package:parabeac_core/generation/generators/pb_generation_manager.dart';
import 'package:parabeac_core/generation/generators/value_objects/template_strategy/pb_template_strategy.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/pb_shared_master_node.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_context.dart';

///Generating a [StatefulWidget]
class StatefulTemplateStrategy extends TemplateStrategy {
  @override
  String generateTemplate(PBIntermediateNode node, PBGenerationManager manager,
      PBContext generatorContext,
      {args}) {
    var widgetName = retrieveNodeName(node);
    var constructorName = '$widgetName';
    var returnStatement = node.generator.generate(node, generatorContext);

    /// Represents the overrides for the constructor.
    var overrides = '';

    /// Represents the overrides for the class variables.
    var overrideVars = '';

    if (node is PBSharedMasterNode && node.overridableProperties.isNotEmpty) {
      node.overridableProperties.forEach((prop) {
        var overrideType = 'Widget?';
        if (prop.type == 'stringValue') {
          overrideType = 'String?';
        }
        overrides += 'this.${prop.propertyName}, ';
        overrideVars += 'final $overrideType ${prop.propertyName};';
      });
    }

    return '''
${manager.generateImports()}

class $widgetName extends StatefulWidget{
  ${node is PBSharedMasterNode ? 'final constraints;' : ''}
  $overrideVars
  const $widgetName(${node is PBSharedMasterNode ? 'this.constraints,' : ''} {Key? key, $overrides}) : super(key: key);
  @override
  _$widgetName createState() => _$widgetName();
}

class _$widgetName extends State<$widgetName>{
  ${manager.generateGlobalVariables()}
  _${manager.generateConstructor(constructorName)}

  @override
  Widget build(BuildContext context){
    ${manager.data.methodVariableStr}
    return $returnStatement;
  }

  ${manager.generateDispose()}
}

''';
  }
}
