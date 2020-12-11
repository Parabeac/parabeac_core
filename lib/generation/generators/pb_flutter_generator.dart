import 'package:parabeac_core/generation/generators/pb_variable.dart';
import 'package:parabeac_core/generation/generators/pb_generation_manager.dart';
import 'package:parabeac_core/generation/generators/util/pb_input_formatter.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/inherited_scaffold.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/inherited_container.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/injected_container.dart';
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

  String generateStatefulWidget(String body, String name) {
    var widgetName = _generateWidgetName(name);
    var constructorName = '_$widgetName';
    return '''
${generateImports()}

class ${widgetName} extends StatefulWidget{
  const ${widgetName}() : super();
  @override
  _${widgetName} createState() => _${widgetName}();
}

class _${widgetName} extends State<${widgetName}>{
  ${generateInstanceVariables()}
  ${generateConstructor(constructorName)}

  @override
  Widget build(BuildContext context){
    return ${body};
  }
}''';
  }

  String generateStatelessWidget(String body, String name) {
    var widgetName = _generateWidgetName(name);
    var constructorName = '_$widgetName';
    return '''
${generateImports()}

class ${widgetName.pascalCase} extends StatelessWidget{
  const ${widgetName.pascalCase}({Key key}) : super(key : key);
  ${generateInstanceVariables()}
  ${generateConstructor(constructorName)}

  @override
  Widget build(BuildContext context){
    return ${body};
  }
}''';
  }

  String _generateWidgetName(name) => PBInputFormatter.formatLabel(
        name,
        isTitle: true,
        space_to_underscore: false,
      );

  String generateConstructor(name) {
    if (constructorVariables == null || constructorVariables.isEmpty) {
      return '';
    }
    var variables = <PBVariable>[];
    var optionalVariables = <PBVariable>[];
    constructorVariables.forEach((param) {
      // Only accept constructor variable if they are
      // part of the variable instances
      if (param.isRequired && instanceVariables.contains(param)) {
        variables.add(param);
      } else if (instanceVariables.contains(param)) {
        optionalVariables.add(param);
      } else {} // Do nothing
    });
    var stringBuffer = StringBuffer();
    stringBuffer.write(name + '(');
    variables.forEach((p) {
      stringBuffer.write('this.' + p.variableName + ',');
    });
    stringBuffer.write('{');
    optionalVariables.forEach((o) {
      stringBuffer.write('this.' + o.variableName + ',');
    });
    stringBuffer.write('});');
    return stringBuffer.toString();
  }

  String generateInstanceVariables() {
    if (instanceVariables == null || instanceVariables.isEmpty) {
      return '';
    }
    var stringBuffer = StringBuffer();
    instanceVariables.forEach((param) {
      stringBuffer.write(
          param.type + ' ' + param.variableName + param.defaultValue + ';\n');
    });

    return stringBuffer.toString();
  }

  /// Formats and returns imports in the list
  String generateImports() {
    var buffer = StringBuffer();
    buffer.write('import \'package:flutter/material.dart\';\n');

    for (var import in imports) {
      buffer.write('import \'$import\';\n');
    }
    return buffer.toString();
  }

  @override
  String generate(PBIntermediateNode rootNode,
      {type = BUILDER_TYPE.STATELESS_WIDGET}) {
    if (rootNode == null) {
      return null;
    }

    ///Automatically assign type for symbols
    if (rootNode is PBSharedMasterNode) {
      type = BUILDER_TYPE.SHARED_MASTER;
    } else if (rootNode is PBSharedInstanceIntermediateNode) {
      type = BUILDER_TYPE.SHARED_INSTANCE;
    } else if (rootNode is InheritedScaffold) {
      type = BUILDER_TYPE.STATEFUL_WIDGET;
    }
    rootNode.builder_type = type;

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

  @override
  void addDependencies(String packageName, String version) {
    pageWriter.addDependency(packageName, version);
  }

  @override
  void addInstanceVariable(PBVariable param) => instanceVariables.add(param);

  @override
  void addConstructorVariable(PBVariable param) =>
      constructorVariables.add(param);

  @override
  void addImport(String value) => imports.add(value);
}
