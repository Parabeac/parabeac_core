import 'package:parabeac_core/controllers/interpret.dart';
import 'package:parabeac_core/design_logic/design_node.dart';
import 'package:parabeac_core/generation/generators/pb_flutter_generator.dart';
import 'package:parabeac_core/generation/generators/pb_generator.dart';
import 'package:parabeac_core/generation/generators/pb_widget_manager.dart';
import 'package:parabeac_core/input/entities/layers/abstract_layer.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/interfaces/pb_inherited_intermediate.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/interfaces/pb_injected_intermediate.dart';
import 'package:parabeac_core/generation/generators/plugins/pb_plugin_node.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_context.dart';
import 'package:parabeac_core/interpret_and_optimize/value_objects/point.dart';

class InjectedNavbar extends PBEgg implements PBInjectedIntermediate {
  var leadingItem;
  var middleItem;
  var trailingItem;
  PBContext currentContext;

  String semanticName = '.*navbar';

  String UUID;

  String widgetType = 'AppBar';

  InjectedNavbar(Point topLeftCorner, Point bottomRightCorner, this.UUID,
      {this.currentContext})
      : super(topLeftCorner, bottomRightCorner, currentContext) {
    generator = PBAppBarGenerator();
  }

  @override
  void addChild(PBIntermediateNode node) {
    if (node is PBInheritedIntermediate) {
      if ((node as PBInheritedIntermediate)
          .originalRef
          .name
          .contains('.*leading')) {
        Interpret()
            .generateNonRootItem((node as PBInheritedIntermediate).originalRef)
            .then((value) => leadingItem = value);
      }

      if ((node as PBInheritedIntermediate)
          .originalRef
          .name
          .contains('.*trailing')) {
        Interpret()
            .generateNonRootItem((node as PBInheritedIntermediate).originalRef)
            .then((value) => trailingItem = value);
      }
      if ((node as PBInheritedIntermediate)
          .originalRef
          .name
          .contains('.*middle')) {
        Interpret()
            .generateNonRootItem((node as PBInheritedIntermediate).originalRef)
            .then((value) => middleItem = value);
      }
    }

    return;
  }

  @override
  void alignChild() {}

  @override
  PBEgg generatePluginNode(
      Point topLeftCorner, Point bottomRightCorner, originalRef) {
    return InjectedNavbar(topLeftCorner, bottomRightCorner, UUID,
        currentContext: currentContext);
  }

  @override
  List<PBIntermediateNode> layoutInstruction(List<PBIntermediateNode> layer) {
    return layer;
  }

  @override
  void extractInformation(DesignNode incomingNode) {}
}

class PBAppBarGenerator extends PBGenerator {
  PBAppBarGenerator() : super('AppBar');

  @override
  String generate(PBIntermediateNode source) {
    if (source is InjectedNavbar) {
      var buffer = StringBuffer();

      buffer.write('AppBar(');
      if (source.leadingItem != null) {
        buffer.write(
            'leading: ${manager.generate(source.leadingItem, type: source.builder_type ?? BUILDER_TYPE.BODY)},');
      }
      if (source.middleItem != null) {
        buffer.write(
            'title: ${manager.generate(source.middleItem, type: source.builder_type ?? BUILDER_TYPE.SCAFFOLD_BODY)},');
      }

      if (source.trailingItem != null) {
        var trailingItem = '';
        trailingItem =
            '${manager.generate(source.trailingItem, type: source.builder_type ?? BUILDER_TYPE.SCAFFOLD_BODY)}';
        buffer.write('actions: [$trailingItem],');
      }

      buffer.write(')');
      return buffer.toString();
    }
  }
}
