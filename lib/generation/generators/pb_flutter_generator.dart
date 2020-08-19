import 'package:parabeac_core/generation/generators/pb_param.dart';
import 'package:parabeac_core/generation/generators/pb_widget_manager.dart';
import 'package:parabeac_core/generation/generators/util/pb_input_formatter.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/pb_shared_instance.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/pb_shared_master_node.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:quick_log/quick_log.dart';

enum BUILDER_TYPE {
  STATEFUL_WIDGET,
  SYMBOL_MASTER,
  SYMBOL_INSTANCE,
  STATELESS_WIDGET,
  BODY,
  SCAFFOLD_BODY,
  EMPTY_PAGE
}

class PBFlutterGenerator extends PBGenerationManager {
  var log = Logger('Flutter Generator');
  PBFlutterGenerator(pageWriter) : super(pageWriter) {
    imports = [];
    body = StringBuffer();
  }

  String generateStatefulWidget(String body, String name) {
    name = PBInputFormatter.formatLabel(name,
        isTitle: true, space_to_underscore: false);
    var widgetName = name;
    var buffer = StringBuffer();
    buffer.write('class ${widgetName} extends StatefulWidget{\n'
        '\tconst ${widgetName}() : super();\n'
        '@override\n_${widgetName} createState() => _${widgetName}();\n}\n\n'
        'class _${widgetName} extends State<${widgetName}>{\n'
        '${generateInstanceVariables()}\n'
        '${generateConstructor(widgetName)}\n'
        '\n@override\nWidget build(BuildContext context){\n'
        'return ${body};\n}\n}');
    return generateImports() + buffer.toString();
  }

  String generateStatelessWidgets(String body, String name) {
    name = PBInputFormatter.formatLabel(name,
        isTitle: true, space_to_underscore: false);
    var buffer = StringBuffer();
    buffer.write('class ${name} extends StatelessWidget{\n'
        '\tconst ${name}({Key key}) : super(key : key);\n'
        '${generateInstanceVariables()}\n'
        '${generateConstructor(name)}\n'
        '\t@override\n\tWidget build(BuildContext context){\n\t return ${body};}}');
    return generateImports() + buffer.toString();
  }

  String generateConstructor(name) {
    if (constructorVariables == null || constructorVariables.isEmpty) {
      return '';
    }
    List<PBParam> variables;
    List<PBParam> optionalVariables;
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
      stringBuffer.write(param.type + ' ' + param.variableName + ';\n');
    });

    return stringBuffer.toString();
  }

  /// Formats and returns imports in the list
  String generateImports() {
    StringBuffer buffer = StringBuffer();
    buffer.write('import \'package:flutter/material.dart\';');

    for (String import in imports) {
      buffer.write('import \'$import\';');
    }
    return buffer.toString();
  }

  @override
  String generate(PBIntermediateNode rootNode,
      {type = BUILDER_TYPE.STATEFUL_WIDGET}) {
    if (rootNode == null) {
      return null;
    }

    ///Automatically assign type for symbols
    if (rootNode is PBSharedMasterNode) {
      type = BUILDER_TYPE.SYMBOL_MASTER;
    } else if (rootNode is PBSharedInstanceIntermediateNode) {
      type = BUILDER_TYPE.SYMBOL_INSTANCE;
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
          return generateStatelessWidgets(
              gen.generate(rootNode), rootNode.name);
          break;
        case BUILDER_TYPE.EMPTY_PAGE:
          return generateImports() + body.toString();
          break;
        case BUILDER_TYPE.SYMBOL_MASTER:
        case BUILDER_TYPE.SYMBOL_INSTANCE:
        case BUILDER_TYPE.BODY:
        default:
          return gen.generate(rootNode);
      }
      //return gen.generate(rootNode);
    } else {
      // print('[ERROR] Generator not registered for ${rootNode}');
      log.error('Generator not registered for ${rootNode}');
    }
    return null;
  }

  @override
  String addDependencies(String packageName, String version) {
    pageWriter.addDependency(packageName, version);
  }

  @override
  void addInstanceVariable(PBParam param) => instanceVariables.add(param);

  @override
  void addConstructorVariable(PBParam param) => constructorVariables.add(param);

  @override
  void addToConstructor(PBParam parameter) {
    // TODO: implement addToConstructor
  }
}
