import 'package:parabeac_core/generation/generators/pb_generation_manager.dart';
import 'package:parabeac_core/generation/generators/util/pb_input_formatter.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/inherited_scaffold.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/pb_shared_instance.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/pb_shared_master_node.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:quick_log/quick_log.dart';
import 'package:recase/recase.dart';

enum BUILDER_TYPE {
  STATEFUL_WIDGET,
  SHARED_MASTER,
  SHARED_INSTANCE,
  STATELESS_WIDGET,
  BODY,
  SCAFFOLD_BODY,
  EMPTY_PAGE
}

class PBFlutterGenerator extends PBGenerationManager {
  var log = Logger('Flutter Generator');
  PBFlutterGenerator(pageWriter) : super(pageWriter) {
    body = StringBuffer();
  }

  ///Generating a [StatefulWidget]
  String generateStatefulWidget(String body, String name) {
    var widgetName = _formatWidgetName(name);
    var constructorName = '_$widgetName';
    return '''
${generateImports()}

class ${widgetName} extends StatefulWidget{
  const ${widgetName}() : super();
  @override
  _${widgetName} createState() => _${widgetName}();
}

class _${widgetName} extends State<${widgetName}>{
  ${generateGlobalVariables()}
  ${generateConstructor(constructorName)}

  @override
  Widget build(BuildContext context){
    return ${body};
  }
}''';
  }

  ///Generating [StatelessWidget]
  String generateStatelessWidget(String body, String name) {
    var widgetName = _formatWidgetName(name);
    var constructorName = '_$widgetName';
    return '''
${generateImports()}

class ${widgetName.pascalCase} extends StatelessWidget{
  const ${widgetName.pascalCase}({Key key}) : super(key : key);
  ${generateGlobalVariables()}
  ${generateConstructor(constructorName)}

  @override
  Widget build(BuildContext context){
    return ${body};
  }
}''';
  }

  String _formatWidgetName(name) => PBInputFormatter.formatLabel(
        name,
        isTitle: true,
        space_to_underscore: false,
      );

  ///Generates a constructor given a name and `constructorVariable`
  String generateConstructor(name) {
    if (constructorVariables == null) {
      return '';
    }
    var stringBuffer = StringBuffer();
    stringBuffer.write(name + '(');
    var param;
    while (constructorVariables.moveNext()) {
      param = constructorVariables.current;
      if (param.isRequired) {
        stringBuffer.write('this.' + param.variableName + ',');
      }
      param = constructorVariables.current;
    }
    stringBuffer.write('{');
    while (constructorVariables.moveNext()) {
      param = constructorVariables.current;
      if (!param.isRequired) {
        stringBuffer.write('this.' + param.variableName + ',');
      }
    }
    stringBuffer.write('});');
    return stringBuffer.toString();
  }

  ///Generate global variables
  String generateGlobalVariables() {
    if (globalVariables == null) {
      return '';
    }
    var stringBuffer = StringBuffer();
    var param;
    while (globalVariables.moveNext()) {
      param = globalVariables.current;
      stringBuffer.write(param.type +
          ' ' +
          param.variableName +
          (param.defaultValue == null ? '' : ' = ${param.defaultValue}') +
          ';\n');
    }
    return stringBuffer.toString();
  }

  BUILDER_TYPE _assignType(PBIntermediateNode rootNode) {
    ///Automatically assign type for symbols
    if (rootNode is PBSharedMasterNode) {
      return BUILDER_TYPE.SHARED_MASTER;
    } else if (rootNode is PBSharedInstanceIntermediateNode) {
      return BUILDER_TYPE.SHARED_INSTANCE;
    } else if (rootNode is InheritedScaffold) {
      return BUILDER_TYPE.STATEFUL_WIDGET;
    }
    return rootNode.builder_type;
  }

  /// Generates the imports
  String generateImports() {
    var buffer = StringBuffer();
    buffer.write('import \'package:flutter/material.dart\';\n');
    while (imports.moveNext()) {
      buffer.write('import \'${imports.current}\';\n');
    }
    return buffer.toString();
  }

  @override
  String generate(PBIntermediateNode rootNode,
      {type = BUILDER_TYPE.STATELESS_WIDGET}) {
    if (rootNode == null) {
      return null;
    }

    rootNode.builder_type = _assignType(rootNode);
    rootNode.generator.manager = this;

    var gen = rootNode.generator;

    if (gen != null) {
      switch (type) {
        case BUILDER_TYPE.STATEFUL_WIDGET:
          return generateStatefulWidget(gen.generate(rootNode), rootNode.name);
          break;
        case BUILDER_TYPE.STATELESS_WIDGET:
          return generateStatelessWidget(gen.generate(rootNode), rootNode.name);
          break;
        case BUILDER_TYPE.EMPTY_PAGE:
          return generateImports() + body.toString();
          break;
        case BUILDER_TYPE.SHARED_MASTER:
          return generateStatelessWidget(gen.generate(rootNode), rootNode.name);
        case BUILDER_TYPE.SHARED_INSTANCE:
        case BUILDER_TYPE.BODY:
        default:
          return gen.generate(rootNode);
      }
    } else {
      log.error('Generator not registered for ${rootNode}');
    }
    return null;
  }
}
