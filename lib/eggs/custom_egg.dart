import 'dart:math';

import 'package:parabeac_core/controllers/main_info.dart';
import 'package:parabeac_core/generation/generators/import_generator.dart';
import 'package:parabeac_core/generation/generators/pb_generator.dart';
import 'package:parabeac_core/generation/generators/plugins/pb_plugin_node.dart';
import 'package:parabeac_core/generation/generators/value_objects/file_structure_strategy/commands/write_symbol_command.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/interfaces/pb_injected_intermediate.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_attribute.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_context.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:uuid/uuid.dart';
import 'package:recase/recase.dart';

class CustomEgg extends PBEgg implements PBInjectedIntermediate {
  @override
  String semanticName = '<custom>';
  CustomEgg(
    String UUID,
    Rectangle frame,
    String name, {
    PBContext currentContext,
  }) : super(UUID, frame, currentContext, name) {
    addAttribute(PBAttribute('child'));
    generator = CustomEggGenerator();
  }

  @override
  void extractInformation(PBIntermediateNode incomingNode) {
    // TODO: implement extractInformation
  }

  @override
  PBEgg generatePluginNode(Rectangle frame, PBIntermediateNode originalRef) {
    return CustomEgg(originalRef.name, frame,
        originalRef.name.replaceAll('<custom>', '').pascalCase);
  }
}

class CustomEggGenerator extends PBGenerator {
  @override
  String generate(PBIntermediateNode source, PBContext context) {
    // TODO: correct import
    source.managerData.addImport(FlutterImport(
      'egg/${source.name.snakeCase}.dart',
      MainInfo().projectName,
    ));
    source.currentContext.configuration.generationConfiguration
        .fileStructureStrategy
        .commandCreated(WriteSymbolCommand(
      Uuid().v4(),
      source.name.snakeCase,
      customBoilerPlate(source.name),
      relativePath: 'egg',
      symbolPath: 'lib',
    ));
    if (source is CustomEgg) {
      return '''
        ${source.name}(
          child: ${source.attributes[0].attributeNode.generator.generate(source.attributes[0].attributeNode, context)}
        )
      ''';
    }
    return '';
  }
}

String customBoilerPlate(String className) {
  return '''
      import 'package:flutter/material.dart';

      class $className extends StatefulWidget{
        final Widget child;
        $className({Key key, this.child}) : super (key: key);

        @override
        _${className}State createState() => _${className}State();
      }

      class _${className}State extends State<$className> {
        @override
        Widget build(BuildContext context){
          return widget.child;
        }
      }
      ''';
}
