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

  // List<PBIntermediateNode> get tabs => getAllAtrributeNamed('tabs');

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
    if (node.name.contains('<tab>')) {
      return 'tabs';
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

    var validChildren =
        children.where((child) => child.attributeName == 'tabs').toList();

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
      var tabs = source.getAllAtrributeNamed(context.tree, 'tabs');

      var buffer = StringBuffer();
      buffer.write('BottomNavigationBar(');
      buffer.write('type: BottomNavigationBarType.fixed,');
      try {
        buffer.write('items:[');
        for (var tab in tabs) {
          buffer.write('BottomNavigationBarItem(');
          var res = context.generationManager.generate(tab, context);
          buffer.write('icon: $res,');
          buffer.write('title: Text(""),');
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
