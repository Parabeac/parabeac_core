import 'package:parabeac_core/controllers/main_info.dart';

import 'package:parabeac_core/generation/generators/pb_generator.dart';
import 'package:parabeac_core/generation/generators/plugins/pb_plugin_node.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/interfaces/pb_injected_intermediate.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/align_strategy.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/child_strategy.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_context.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_intermediate_node_tree.dart';
import 'dart:math';

class InjectedTabBar extends PBEgg implements PBInjectedIntermediate {
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
  PBEgg generatePluginNode(Rectangle3D frame, PBIntermediateNode originalRef,
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

    var validChildren = children
        .where((child) =>
            child.attributeName == TAB_ATTR_NAME ||
            child.attributeName == BACKGROUND_ATTR_NAME)
        .toList();

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
        MainInfo().sentry.captureException(
              exception: e,
              stackTrace: stackTrace,
            );
        buffer.write('),');
      }
      buffer.write('],');
      buffer.write(')');
      return buffer.toString();
    }
  }
}
