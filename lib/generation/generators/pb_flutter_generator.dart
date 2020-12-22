import 'package:parabeac_core/generation/generators/pb_generation_manager.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:quick_log/quick_log.dart';
import 'package:parabeac_core/generation/generators/value_objects/pb_template_strategy.dart';

class PBFlutterGenerator extends PBGenerationManager {
  var log = Logger('Flutter Generator');
  final DEFAULT_STRATEGY = EmptyPageTemplateStrategy();
  PBFlutterGenerator(pageWriter) : super(pageWriter) {
    body = StringBuffer();
  }

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
  String generate(
    PBIntermediateNode rootNode,
  ) {
    if (rootNode == null) {
      return null;
    }
    rootNode.generator.manager = this;
    if (rootNode.generator == null) {
      log.error('Generator not registered for ${rootNode}');
    }
    return rootNode.generator?.templateStrategy
            ?.generateTemplate(rootNode, this) ??

        ///if there is no [TemplateStrategy] we are going to use `DEFAULT_STRATEGY`
        DEFAULT_STRATEGY.generateTemplate(rootNode, this);
  }
}
