import 'package:parabeac_core/generation/generators/pb_generation_manager.dart';
import 'package:parabeac_core/generation/generators/util/pb_input_formatter.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';

abstract class TemplateStrategy {
  String generateTemplate(PBIntermediateNode node, PBGenerationManager manager,
      {var args});
  String retrieveNodeName(var node) {
    var formatter = (name) => PBInputFormatter.formatLabel(name,
        isTitle: true, space_to_underscore: false);
    var widgetName;
    if (node is PBIntermediateNode) {
      widgetName = formatter(node.name);
    } else if (node is String) {
      widgetName = formatter(node);
    } else {
      widgetName = node;
    }
    return widgetName;
  }

  String getAppbar(node, manager) {
    if (node.navbar != null) {
      node.navbar.generator.manager = manager;
      return 'appBar: ${node.navbar.generator.generate(node.navbar)}, ';
    } else {
      return '';
    }
  }

  String getTabbar(node, manager) {
    if (node.tabbar != null) {
      node.tabbar.generator.manager = manager;
      return 'bottomNavigationBar: ${node.tabbar.generator.generate(node.tabbar)},';
    } else {
      return '';
    }
  }
}
