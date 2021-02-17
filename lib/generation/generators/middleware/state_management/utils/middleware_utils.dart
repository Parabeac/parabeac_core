import 'package:parabeac_core/generation/generators/attribute-helper/pb_generator_context.dart';
import 'package:parabeac_core/generation/generators/pb_generation_manager.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/pb_shared_master_node.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:recase/recase.dart';

class MiddlewareUtils {
  static String generateChangeNotifierClass(
    String states,
    String defaultStateName,
    PBGenerationManager manager,
    String defaultWidgetName, {
    List<PBSharedParameterProp> overrideProperties,
  }) {
    var overrideVars = ''; // Variables outside of initializer
    var overrideAttr = ''; // Attributes that will be part of initializer

    overrideProperties?.forEach((property) {
      overrideVars += 'final ${property.friendlyName};';
      overrideAttr += 'this.${property.friendlyName}, ';
    });

    return '''
      import 'package:flutter/material.dart';
      class ${defaultStateName} extends ChangeNotifier {
      ${states}
      ${overrideVars}

      Widget defaultWidget;
      ${defaultStateName}({$overrideAttr}){
        defaultWidget = ${defaultWidgetName};
      }
      }
      ''';
  }

  static String generateVariable(PBIntermediateNode node) {
    return 'var ${node.name.camelCase} = ' +
        node?.generator?.generate(node ?? '',
            GeneratorContext(sizingContext: SizingValueContext.PointValue)) +
        ';';
  }
}
