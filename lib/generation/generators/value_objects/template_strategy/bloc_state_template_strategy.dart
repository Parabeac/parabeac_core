import 'package:parabeac_core/generation/generators/pb_generation_manager.dart';
import 'package:parabeac_core/generation/generators/value_objects/template_strategy/pb_template_strategy.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_context.dart';
import 'package:recase/recase.dart';

class BLoCStateTemplateStrategy extends TemplateStrategy {
  bool isFirst = true;
  String abstractClassName;
  BLoCStateTemplateStrategy({this.isFirst, this.abstractClassName});
  @override
  String generateTemplate(PBIntermediateNode node, PBGenerationManager manager,
      PBContext generatorContext,
      {args}) {
    node.managerData.hasParams = true;
    node.managerData.hasParams = false;

    return '''
${isFirst ? _getHeader(manager) : ''}

class ${node.name.pascalCase}State extends ${abstractClassName.pascalCase}State{}''';
  }

  String _getHeader(manager) {
    return '''
    part of '${abstractClassName.snakeCase}_cubit.dart';

    @immutable
    abstract class ${abstractClassName.pascalCase}State{
      
    }
    ''';
  }
}
