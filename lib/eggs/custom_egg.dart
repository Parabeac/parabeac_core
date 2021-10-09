import 'dart:math';

import 'package:directed_graph/directed_graph.dart';
import 'package:parabeac_core/controllers/main_info.dart';
import 'package:parabeac_core/generation/generators/import_generator.dart';
import 'package:parabeac_core/generation/generators/pb_generator.dart';
import 'package:parabeac_core/generation/generators/plugins/pb_plugin_node.dart';
import 'package:parabeac_core/generation/generators/value_objects/file_structure_strategy/commands/write_symbol_command.dart';
import 'package:parabeac_core/generation/generators/value_objects/file_structure_strategy/file_ownership_policy.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/interfaces/pb_injected_intermediate.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/pb_shared_instance.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/pb_shared_master_node.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/child_strategy.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_context.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_intermediate_node_tree.dart';
import 'package:uuid/uuid.dart';
import 'package:recase/recase.dart';

class CustomEgg extends PBEgg implements PBInjectedIntermediate {
  @override
  String semanticName = '<custom>';
  CustomEgg(String UUID, Rectangle3D frame, String name)
      : super(UUID, frame, name) {
    generator = CustomEggGenerator();
    childrenStrategy = TempChildrenStrategy('child');
  }

  @override
  void extractInformation(PBIntermediateNode incomingNode) {
    // TODO: implement extractInformation
  }

  @override
  PBEgg generatePluginNode(Rectangle3D frame, PBIntermediateNode originalRef,
      PBIntermediateTree tree) {
    return CustomEgg(
      originalRef.UUID,
      frame,
      originalRef.name.replaceAll('<custom>', '').pascalCase,
    );
  }

  /// Handles `iNode` to convert into a [CustomEgg].
  ///
  /// Returns the [PBIntermediateNode] that should go into the [PBIntermediateTree]
  PBIntermediateNode handleIntermediateNode(
    PBIntermediateNode iNode,
    PBIntermediateNode parent,
    CustomEgg tag,
    PBIntermediateTree tree,
  ) {
    if (iNode is PBSharedMasterNode) {
      iNode.name = iNode.name.replaceAll('<custom>', '');
      var tempGroup = CustomEgg(
        null,
        iNode.frame,
        iNode.name.pascalCase + 'Custom',
      );

      tree.addEdges(
          tempGroup, tree.childrenOf(iNode).cast<Vertex<PBIntermediateNode>>());

      tree.replaceChildrenOf(iNode, [tempGroup]);
      return iNode;
    } else if (iNode is PBSharedInstanceIntermediateNode) {
      var tempGroup = CustomEgg(
        null,
        iNode.frame,
        tag.name + 'Custom',
      );

      iNode.parent = parent;

      tree.replaceNode(iNode, tempGroup);

      tree.addEdges(tempGroup, [iNode]);

      return tempGroup;
    } else {
      // [iNode] needs a parent and has not been added to the [tree] by [tree.addEdges]
      iNode.parent = parent;
      // If `iNode` has no children, it likely means we want to wrap `iNode` in [CustomEgg]
      if (tree.childrenOf(iNode).isEmpty) {
        // Generate new [CustomEgg] with a new UUID to prevent cycles.
        //? TODO: should every [CustomEgg] have unique UUID or inherit from iNode like it is currently doing in `generatePluginNode`?
        var newTag = CustomEgg(
          null,
          iNode.frame,
          tag.name,
        );
        /// Wrap `iNode` in `newTag` and make `newTag` child of `parent`.
        tree.removeEdges(iNode.parent, [iNode]);
        tree.addEdges(newTag, [iNode]);
        tree.addEdges(parent, [newTag]);
        return newTag;
      }
      tree.replaceNode(iNode, tag, acceptChildren: true);

      return tag;
    }
  }
}

class CustomEggGenerator extends PBGenerator {
  @override
  String generate(PBIntermediateNode source, PBContext context) {
    var children = context.tree.childrenOf(source);
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
          child: ${children[0].generator.generate(children[0], context)}
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
