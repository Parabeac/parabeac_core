import 'package:get_it/get_it.dart';
import 'package:parabeac_core/analytics/amplitude_analytics_service.dart';
import 'package:parabeac_core/controllers/main_info.dart';
import 'package:parabeac_core/generation/generators/import_generator.dart';
import 'package:parabeac_core/generation/generators/pb_generator.dart';
import 'package:parabeac_core/generation/generators/plugins/pb_plugin_node.dart';
import 'package:parabeac_core/generation/generators/util/pb_input_formatter.dart';
import 'package:parabeac_core/generation/generators/value_objects/file_structure_strategy/commands/write_symbol_command.dart';
import 'package:parabeac_core/generation/generators/value_objects/file_structure_strategy/file_ownership_policy.dart';
import 'package:parabeac_core/generation/generators/value_objects/file_structure_strategy/path_services/path_service.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/interfaces/pb_injected_intermediate.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_constraints.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/pb_shared_instance.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/pb_shared_master_node.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/child_strategy.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/element_storage.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_context.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_intermediate_node_tree.dart';
import 'package:uuid/uuid.dart';
import 'package:recase/recase.dart';
import 'package:path/path.dart' as path;

class CustomTag extends PBTag implements PBInjectedIntermediate {
  @override
  String semanticName = '<custom>';

  @override
  String name;

  @override
  ParentLayoutSizing layoutCrossAxisSizing;
  @override
  ParentLayoutSizing layoutMainAxisSizing;

  bool isComponent;
  CustomTag(
    String UUID,
    Rectangle3D frame,
    this.name, {
    PBIntermediateConstraints constraints,
    this.layoutCrossAxisSizing,
    this.layoutMainAxisSizing,
    this.isComponent,
  }) : super(
          UUID,
          frame,
          name,
          contraints: constraints,
        ) {
    generator ??= _getGenerator();
    childrenStrategy = TempChildrenStrategy('child');
  }

  /// Function that examines the configuration and assigns a generator
  /// to `this` [CustomTag] and assigns it a State management generator
  PBGenerator _getGenerator() {
    // if (MainInfo().configuration.stateManagement.toLowerCase() == 'bloc') {
    //   return CustomTagBlocGenerator();
    // }
    return CustomTagGenerator();
  }

  @override
  void extractInformation(PBIntermediateNode incomingNode) {}

  @override
  PBTag generatePluginNode(Rectangle3D frame, PBIntermediateNode originalRef,
      PBIntermediateTree tree) {
    return CustomTag(
      null,
      frame.copyWith(),
      originalRef.name.replaceAll('<custom>', '').pascalCase + 'Custom',
      constraints: originalRef.constraints.copyWith(),
      layoutCrossAxisSizing: originalRef.layoutCrossAxisSizing,
      layoutMainAxisSizing: originalRef.layoutMainAxisSizing,
      isComponent: originalRef is PBSharedMasterNode &&
          originalRef.componentSetName ==
              null, //Variable used to add extra info. to custom file.
    );
  }
}

class CustomTagGenerator extends PBGenerator {
  /// Variable that dictates in what directory the tag will be generated.
  static String DIRECTORY_GEN = GetIt.I.get<PathService>().widgetsRelativePath;
  static String DIRECTORY_CUSTOM =
      GetIt.I.get<PathService>().customRelativePath;

  @override
  String generate(PBIntermediateNode source, PBContext context) {
    var firstChild = context.tree.childrenOf(source).first;
    var customDirectory;

    /// Need to check if the custom tag belongs to a different page.
    /// This is because we need to get the correct tree name for importing.
    if (firstChild is PBSharedInstanceIntermediateNode) {
      var storage = ElementStorage();
      var treeId = storage.elementToTree[firstChild.SYMBOL_ID];
      var componentTree = storage.treeUUIDs[treeId];
      customDirectory =
          path.join(DIRECTORY_GEN, componentTree.name, DIRECTORY_CUSTOM);
    } else {
      customDirectory =
          path.join(DIRECTORY_GEN, context.tree.name, DIRECTORY_CUSTOM);
    }

    var children = context.tree.childrenOf(source);
    var titleName = PBInputFormatter.formatLabel(
      source.name,
      isTitle: true,
      destroySpecialSym: true,
    );
    var cleanName = PBInputFormatter.formatLabel(source.name.snakeCase);

    // TODO: correct import
    context.managerData.addImport(FlutterImport(
      '$customDirectory/$cleanName.dart',
      MainInfo().projectName,
    ));

    context.configuration.generationConfiguration.fileStructureStrategy
        .commandCreated(
      WriteSymbolCommand(
        Uuid().v4(),
        cleanName,
        customBoilerPlate(
          titleName,
          context.tree.childrenOf(source).first,
          context,
          source,
        ),
        symbolPath: '$customDirectory',
        ownership: FileOwnership.DEV,
      ),
    );

    if (source is CustomTag) {
      // Add tag to analytics
      if (!context.tree.lockData) {
        GetIt.I
            .get<AmplitudeService>()
            .addToSpecified('CustomTag', 'tag', 'Number of tags generated');
      }
      return '''
        $titleName(
          child: ${children.elementAt(0).generator.generate(children.elementAt(0), context)}
        )
      ''';
    }
    return '';
  }

  String customBoilerPlate(
    String className,
    PBIntermediateNode child,
    PBContext context,
    CustomTag source,
  ) {
    /// Import variable in case we need to import
    /// component file inside custom file
    var import = '';

    /// Suffix to be appended after `widget.child`.
    /// The '!' is for null safety. Optionally,
    /// we can also add reference to the component.
    var suffix = '!';
    if (source.isComponent) {
      var baseCompName = className.replaceAll('Custom', '');
      import = FlutterImport(
        path.join(
          WriteSymbolCommand.DEFAULT_SYMBOL_PATH,
          context.tree.name,
          '${baseCompName.snakeCase}.g.dart',
        ),
        MainInfo().projectName,
      ).toString();
      suffix = '?? const $baseCompName()';
    }

    return '''
      $import
      import 'package:flutter/material.dart';

      class $className extends StatefulWidget{
        final Widget? child;
        $className({Key? key, this.child,}) : super (key: key);

        @override
        _${className}State createState() => _${className}State();
      }

      class _${className}State extends State<$className> {
        @override
        Widget build(BuildContext context){
          return widget.child $suffix;
        }
      }
      ''';
  }
}
