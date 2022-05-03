import 'package:parabeac_core/controllers/main_info.dart';
import 'package:parabeac_core/generation/generators/import_generator.dart';
import 'package:parabeac_core/generation/generators/pb_generator.dart';
import 'package:parabeac_core/generation/generators/plugins/pb_plugin_node.dart';
import 'package:parabeac_core/generation/generators/util/pb_input_formatter.dart';
import 'package:parabeac_core/generation/generators/value_objects/file_structure_strategy/commands/write_symbol_command.dart';
import 'package:parabeac_core/generation/generators/value_objects/file_structure_strategy/file_ownership_policy.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/injected_container.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/interfaces/pb_injected_intermediate.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/align_strategy.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/child_strategy.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_context.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_intermediate_node_tree.dart';
import 'package:recase/recase.dart';
import 'package:sentry/sentry.dart';

import 'package:uuid/uuid.dart';

class InjectedTabBar extends PBTag implements PBInjectedIntermediate {
  @override
  String semanticName = '<tabbar>';

  static final TAB_ATTR_NAME = 'tabs';
  static final BACKGROUND_ATTR_NAME = 'background';

  final nameToAttr = {
    '<tab>': TAB_ATTR_NAME,
    '<background>': BACKGROUND_ATTR_NAME,
  };

  @override
  AlignStrategy alignStrategy = NoAlignment();

  InjectedTabBar(
    String UUID,
    Rectangle3D frame,
    String name,
  ) : super(UUID, frame, name) {
    generator = PBTabBarGenerator();
    childrenStrategy = MultipleChildStrategy('children');
  }

  @override
  String getAttributeNameOf(PBIntermediateNode node) {
    var matchingKey = nameToAttr.keys
        .firstWhere((key) => node.name.contains(key), orElse: () => null);

    if (matchingKey != null) {
      return nameToAttr[matchingKey];
    }

    return super.getAttributeNameOf(node);
  }

  @override
  List<PBIntermediateNode> layoutInstruction(List<PBIntermediateNode> layer) {
    return layer;
  }

  @override
  void extractInformation(PBIntermediateNode incomingNode) {}

  @override
  PBTag generatePluginNode(Rectangle3D frame, PBIntermediateNode originalRef,
      PBIntermediateTree tree) {
    var tabbar = InjectedTabBar(
      originalRef.UUID,
      frame,
      originalRef.name,
    );

    tree
        .childrenOf(tabbar)
        .forEach((child) => child.attributeName = getAttributeNameOf(child));

    return tabbar;
  }

  @override
  void handleChildren(PBContext context) {
    var children = context.tree.childrenOf(this);

    var background = children.firstWhere(
        (element) => element.attributeName == BACKGROUND_ATTR_NAME,
        orElse: () => null);

    var tabs = children
        .where((child) => child.attributeName == TAB_ATTR_NAME)
        .toList();

    var validChildren = <PBIntermediateNode>[];
    for (var child in tabs) {
      // Inject a Container into Tabs for sizing
      var container = InjectedContainer(
        null,
        child.frame,
        name: child.name,
        constraints: child.constraints.copyWith(),
      )..attributeName = child.attributeName;
      context.tree.removeEdges(child.parent, [child]);
      context.tree.addEdges(container, [child]);
      validChildren.add(container);
    }

    if (background != null) {
      validChildren.add(background);
    }

    // Ensure only nodes with `tab` remain
    context.tree.replaceChildrenOf(this, validChildren);
  }
}

class PBTabBarGenerator extends PBGenerator {
  PBTabBarGenerator() : super();

  @override
  String generate(PBIntermediateNode source, PBContext context) {
    // generatorContext.sizingContext = SizingValueContext.PointValue;
    if (source is InjectedTabBar) {
      // var tabs = source.tabs;
      var tabs = source.getAllAtrributeNamed(
          context.tree, InjectedTabBar.TAB_ATTR_NAME);
      var background = context.tree.childrenOf(source).firstWhere(
          (child) => child.attributeName == InjectedTabBar.BACKGROUND_ATTR_NAME,
          orElse: () => null);

      // Sort tabs from Left to Right
      tabs.sort((a, b) => a.frame.left.compareTo(b.frame.left));

      var buffer = StringBuffer();
      buffer.write('BottomNavigationBar(');

      if (background != null) {
        // TODO: PBColorGen may need a refactor in order to support `backgroundColor` when inside this tag
        buffer.write(
            'backgroundColor: Color(${background.auxiliaryData?.color?.toString()}),');
      }

      buffer.write('type: BottomNavigationBarType.fixed,');
      try {
        buffer.write('items:[');
        for (var tab in tabs) {
          buffer.write('BottomNavigationBarItem(');
          var res = context.generationManager.generate(tab, context);
          buffer.write('icon: $res,');
          buffer.write('label: "",');
          buffer.write('),');
        }
      } catch (e, stackTrace) {
        Sentry.captureException(e, stackTrace: stackTrace);
        buffer.write('),');
      }
      buffer.write('],');
      buffer.write(')');

      var className =
          PBInputFormatter.formatLabel(source.parent.name, isTitle: true) +
              'Tabbar';

      // TODO: correct import
      context.managerData.addImport(FlutterImport(
        'controller/${className.snakeCase}.dart',
        MainInfo().projectName,
      ));

      context.configuration.generationConfiguration.fileStructureStrategy
          .commandCreated(WriteSymbolCommand(
        Uuid().v4(),
        className.snakeCase,
        tabBarBody(
            className, buffer.toString(), context.managerData.importsList),
        symbolPath: 'lib',
        ownership: FileOwnership.DEV,
      ));

      return '$className()';
    }
  }

  String tabBarBody(
      String className, String body, List<FlutterImport> importsList) {
    var imports = '';

    importsList.forEach((import) {
      if (import.package != MainInfo().projectName) {
        imports += import.toString() + '\n';
      }
    });
    return '''
      $imports

      class $className extends StatefulWidget {
        final Widget? child;
        $className({Key? key, this.child}) : super (key: key);

        @override
        _${className}State createState() => _${className}State();

      }

      class _${className}State extends State<$className> {
        @override
        Widget build(BuildContext context){
          return $body;
        }
      }
      ''';
  }
}
