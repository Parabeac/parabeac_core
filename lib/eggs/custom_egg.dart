import 'package:parabeac_core/controllers/main_info.dart';
import 'package:parabeac_core/design_logic/design_node.dart';
import 'package:parabeac_core/generation/generators/import_generator.dart';
import 'package:parabeac_core/generation/generators/pb_generator.dart';
import 'package:parabeac_core/generation/generators/plugins/pb_plugin_node.dart';
import 'package:parabeac_core/generation/generators/value_objects/file_structure_strategy/commands/write_symbol_command.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/injected_container.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/interfaces/pb_injected_intermediate.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_attribute.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_context.dart';
import 'package:parabeac_core/interpret_and_optimize/value_objects/point.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:uuid/uuid.dart';
import 'package:recase/recase.dart';

class CustomEgg extends PBEgg implements PBInjectedIntermediate {
  @override
  String semanticName = '<custom>';
  CustomEgg(
    Point topLeftCorner,
    Point bottomRightCorner,
    String name, {
    PBContext currentContext,
  }) : super(topLeftCorner, bottomRightCorner, currentContext, name) {
    addAttribute(PBAttribute('child'));
    generator = CustomEggGenerator();
  }

  @override
  void addChild(PBIntermediateNode node) {
    getAttributeNamed('child').attributeNode = node;
  }

  @override
  void alignChild() {
    var tempNode = InjectedContainer(
      child.bottomRightCorner,
      child.topLeftCorner,
      child.name,
      child.UUID,
    )..addChild(child);

    getAttributeNamed('title').attributeNode = tempNode;
  }

  @override
  void extractInformation(DesignNode incomingNode) {
    // TODO: implement extractInformation
  }

  @override
  PBEgg generatePluginNode(
      Point topLeftCorner, Point bottomRightCorner, DesignNode originalRef) {
    return CustomEgg(topLeftCorner, bottomRightCorner,
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
