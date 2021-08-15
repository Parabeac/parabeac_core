import 'dart:math';

import 'package:parabeac_core/controllers/main_info.dart';
import 'package:parabeac_core/generation/generators/import_generator.dart';
import 'package:parabeac_core/generation/generators/pb_generator.dart';
import 'package:parabeac_core/generation/generators/plugins/pb_plugin_node.dart';
import 'package:parabeac_core/generation/generators/value_objects/file_structure_strategy/commands/write_symbol_command.dart';
import 'package:parabeac_core/generation/generators/value_objects/file_structure_strategy/file_ownership_policy.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/interfaces/pb_injected_intermediate.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/child_strategy.dart';
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
    String name,
  ) : super(UUID, frame, name) {
    generator = CustomEggGenerator();
    childrenStrategy = TempChildrenStrategy('child');
  }

  @override
  void extractInformation(PBIntermediateNode incomingNode) {
    // TODO: implement extractInformation
  }

  @override
  PBEgg generatePluginNode(Rectangle frame, PBIntermediateNode originalRef) {
    var egg = CustomEgg(originalRef.UUID, frame,
        originalRef.name.replaceAll('<custom>', '').pascalCase);
    //FIXME originalRef.children.forEach((child) => egg.addChild(child));
    return egg;
  }
}

class CustomEggGenerator extends PBGenerator {
  @override
  String generate(PBIntermediateNode source, PBContext context) {
    // TODO: correct import
    context.managerData.addImport(FlutterImport(
      'egg/${source.name.snakeCase}.dart',
      MainInfo().projectName,
    ));
    context.configuration.generationConfiguration.fileStructureStrategy
        .commandCreated(WriteSymbolCommand(
            Uuid().v4(), source.name.snakeCase, customBoilerPlate(source.name),
            relativePath: 'egg',
            symbolPath: 'lib',
            ownership: FileOwnership.DEV));
    if (source is CustomEgg) {
      return '''
        ${source.name}(
          child: ${source.children[0].generator.generate(source.children[0], context)}
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
