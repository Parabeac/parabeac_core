import 'package:parabeac_core/controllers/main_info.dart';
import 'package:parabeac_core/design_logic/design_node.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_attribute.dart';
import 'package:parabeac_core/generation/generators/pb_generator.dart';
import 'package:parabeac_core/generation/generators/plugins/pb_plugin_node.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/interfaces/pb_inherited_intermediate.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/interfaces/pb_injected_intermediate.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_context.dart';
import 'package:parabeac_core/interpret_and_optimize/value_objects/point.dart';

import 'injected_tab.dart';

class InjectedTabBar extends PBEgg implements PBInjectedIntermediate {
  @override
  final String UUID;
  @override
  PBContext currentContext;
  @override
  String semanticName = '<tabbar>';

  List<PBIntermediateNode> get tabs => getAttributeNamed('tabs').attributeNodes;

  InjectedTabBar(
    Point topLeftCorner,
    Point bottomRightCorner,
    String name,
    this.UUID, {
    this.currentContext,
  }) : super(topLeftCorner, bottomRightCorner, currentContext, name) {
    generator = PBTabBarGenerator();
    addAttribute(PBAttribute('tabs'));
  }

  @override
  void addChild(PBIntermediateNode node) {
    if (node is PBInheritedIntermediate) {
      if ((node as PBInheritedIntermediate)
          .originalRef
          .name
          .contains('<tab>')) {
        assert(node is! Tab, 'node should be a Tab');
        getAttributeNamed('tabs').attributeNodes.add(node);
      }
    }

    if (node is Tab) {
      getAttributeNamed('tabs').attributeNodes.add(node);
    }
  }

  @override
  List<PBIntermediateNode> layoutInstruction(List<PBIntermediateNode> layer) {}

  @override
  void alignChild() {}

  @override
  PBEgg generatePluginNode(
      Point topLeftCorner, Point bottomRightCorner, DesignNode originalRef) {
    return InjectedTabBar(
        topLeftCorner, bottomRightCorner, UUID, originalRef.name,
        currentContext: currentContext);
  }

  @override
  void extractInformation(DesignNode incomingNode) {
    // TODO: implement extractInformation
  }
}

class PBTabBarGenerator extends PBGenerator {
  PBTabBarGenerator() : super();

  @override
  String generate(PBIntermediateNode source, PBContext generatorContext) {
    generatorContext.sizingContext = SizingValueContext.PointValue;
    if (source is InjectedTabBar) {
      var tabs = source.tabs;

      var buffer = StringBuffer();
      buffer.write('BottomNavigationBar(');
      buffer.write('type: BottomNavigationBarType.fixed,');
      try {
        buffer.write('items:[');
        for (var i = 0; i < tabs.length; i++) {
          buffer.write('BottomNavigationBarItem(');
          var res = generatorContext.generationManager.generate(tabs[i].child);
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
