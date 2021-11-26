import 'package:parabeac_core/controllers/main_info.dart';
import 'package:parabeac_core/generation/generators/import_generator.dart';
import 'package:parabeac_core/generation/generators/pb_generator.dart';
import 'package:parabeac_core/generation/generators/plugins/pb_plugin_node.dart';
import 'package:parabeac_core/generation/generators/value_objects/file_structure_strategy/commands/write_symbol_command.dart';
import 'package:parabeac_core/generation/generators/value_objects/file_structure_strategy/file_ownership_policy.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/interfaces/pb_injected_intermediate.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/child_strategy.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_context.dart';
import 'package:recase/recase.dart';

import 'package:parabeac_core/interpret_and_optimize/helpers/pb_intermediate_node_tree.dart';
import 'package:uuid/uuid.dart';

class InjectedAppbar extends PBTag implements PBInjectedIntermediate {
  @override
  String semanticName = '<navbar>';

  /// String representing what the <leading> tag maps to
  static final LEADING_ATTR_NAME = 'leading';

  /// String representing what the <middle> tag maps to
  static final MIDDLE_ATTR_NAME = 'title';

  /// String representing what the <trailing> tag maps to
  static final TRAILING_ATTR_NAME = 'actions';

  /// String representing what the <background> tag maps to
  static final BACKGROUND_ATTR_NAME = 'background';

  final tagToName = {
    '<leading>': LEADING_ATTR_NAME,
    '<middle>': MIDDLE_ATTR_NAME,
    '<trailing>': TRAILING_ATTR_NAME,
    '<background>': BACKGROUND_ATTR_NAME
  };

  InjectedAppbar(
    String UUID,
    Rectangle3D frame,
    String name,
  ) : super(UUID, frame, name) {
    generator = PBAppBarGenerator();
    childrenStrategy = MultipleChildStrategy('children');
  }

  @override
  String getAttributeNameOf(PBIntermediateNode node) {
    if (node is PBIntermediateNode) {
      /// Iterate `keys` of [tagToName] to see if
      /// any `key` matches [node.name]
      for (var key in tagToName.keys) {
        if (node.name.contains(key)) {
          return tagToName[key];
        }
      }
    }

    return super.getAttributeNameOf(node);
  }

  @override
  PBTag generatePluginNode(Rectangle3D frame, PBIntermediateNode originalRef,
      PBIntermediateTree tree) {
    var appbar = InjectedAppbar(
      originalRef.UUID,
      frame,
      originalRef.name,
    );

    tree
        .childrenOf(appbar)
        .forEach((child) => child.attributeName = getAttributeNameOf(child));

    return appbar;
  }

  @override
  void handleChildren(PBContext context) {
    var children = context.tree.childrenOf(this);

    // Remove children that have an invalid `attributeName`
    var validChildren = children.where(_isValidNode).toList();

    context.tree.replaceChildrenOf(this, validChildren);
  }

  /// Returns [true] if `node` has a valid `attributeName` in the eyes of the [InjectedAppbar].
  /// Returns [false] otherwise.
  bool _isValidNode(PBIntermediateNode node) =>
      tagToName.values.any((name) => name == node.attributeName);

  @override
  List<PBIntermediateNode> layoutInstruction(List<PBIntermediateNode> layer) {
    return layer;
  }

  @override
  void extractInformation(PBIntermediateNode incomingNode) {}
}

class PBAppBarGenerator extends PBGenerator {
  PBAppBarGenerator() : super();

  @override
  String generate(PBIntermediateNode source, PBContext generatorContext) {
    // TODO: this ignores the creation of appbar
    // TODO: fix it on later iterations
    return null;
    // generatorContext.sizingContext = SizingValueContext.PointValue;
    if (source is InjectedAppbar) {
      var buffer = StringBuffer();

      buffer.write('AppBar(');

      // Get necessary attributes that need to be processed separately
      var background = generatorContext.tree.childrenOf(source).firstWhere(
          (child) => child.attributeName == InjectedAppbar.BACKGROUND_ATTR_NAME,
          orElse: () => null);
      var actions = generatorContext.tree.childrenOf(source).where(
          (child) => child.attributeName == InjectedAppbar.TRAILING_ATTR_NAME);
      var children = generatorContext.tree.childrenOf(source).where((child) =>
          child.attributeName != InjectedAppbar.TRAILING_ATTR_NAME &&
          child.attributeName != InjectedAppbar.BACKGROUND_ATTR_NAME);

      if (background != null && background.auxiliaryData?.color != null) {
        // TODO: PBColorGen may need a refactor in order to support `backgroundColor` when inside this tag
        buffer.write(
            'backgroundColor: Color(${background.auxiliaryData?.color?.toString()}),');
      } else {
        buffer.write(
            'backgroundColor: Color(${generatorContext.tree.rootNode.auxiliaryData.color.toString()}),');
      }
      if (actions.isNotEmpty) {
        buffer.write(
            '${InjectedAppbar.TRAILING_ATTR_NAME}: ${_getActions(actions, generatorContext)},');
      }
      children.forEach((child) => buffer.write(
          '${child.attributeName}: ${child.generator.generate(child, generatorContext)},'));

      buffer.write(')');

      var className = source.parent.name + 'Appbar';

      // TODO: correct import
      generatorContext.managerData.addImport(FlutterImport(
        'controller/${className.snakeCase}.dart',
        MainInfo().projectName,
      ));

      generatorContext
          .configuration.generationConfiguration.fileStructureStrategy
          .commandCreated(WriteSymbolCommand(
        Uuid().v4(),
        className.snakeCase,
        appBarBody(className, buffer.toString(),
            generatorContext.managerData.importsList),
        relativePath: 'controller',
        symbolPath: 'lib',
        ownership: FileOwnership.DEV,
      ));

      return '$className()';
    }
  }

  String appBarBody(
      String className, String body, List<FlutterImport> importsList) {
    var imports = '';

    importsList.forEach((import) {
      if (import.package != MainInfo().projectName) {
        imports += import.toString() + '\n';
      }
    });
    return '''
      $imports

      class $className extends StatefulWidget implements PreferredSizeWidget{
        final Widget? child;
        $className({Key? key, this.child}) : super (key: key);

        @override
        _${className}State createState() => _${className}State();

        @override
        Size get preferredSize => Size.fromHeight(AppBar().preferredSize.height);
      }

      class _${className}State extends State<$className> {
        @override
        Widget build(BuildContext context){
          return $body;
        }
      }
      ''';
  }

  /// Returns list ot `actions` as individual [PBIntermediateNodes]
  String _getActions(Iterable<PBIntermediateNode> actions, PBContext context) {
    var buffer = StringBuffer();

    buffer.write('[');
    actions.forEach((action) =>
        buffer.write('${action.generator.generate(action, context)},'));
    buffer.write(']');

    return buffer.toString();
  }

  // String _wrapOnIconButton(String body) {
  //   return '''
  //     IconButton(
  //       icon: $body,
  //       onPressed: () {
  //         // TODO: Fill action
  //       }
  //     )
  //   ''';
  // }
}
