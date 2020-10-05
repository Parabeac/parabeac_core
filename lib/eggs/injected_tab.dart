import 'package:parabeac_core/design_logic/design_node.dart';
import 'package:parabeac_core/generation/generators/pb_flutter_generator.dart';
import 'package:parabeac_core/generation/generators/pb_generator.dart';
import 'package:parabeac_core/generation/prototyping/pb_prototype_node.dart';
import 'package:parabeac_core/input/sketch/entities/layers/abstract_group_layer.dart';
import 'package:parabeac_core/input/sketch/entities/layers/symbol_instance.dart';
import 'package:parabeac_core/input/sketch/entities/layers/symbol_master.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/interfaces/pb_injected_intermediate.dart';
import 'package:parabeac_core/generation/generators/plugins/pb_plugin_node.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_context.dart';
import 'package:parabeac_core/interpret_and_optimize/value_objects/point.dart';
import 'package:uuid/uuid.dart';

class Tab extends PBEgg implements PBInjectedIntermediate {
  PBContext currentContext;

  String widgetType = 'Tab';

  PrototypeNode prototypeNode;

  Tab(
    Point topLeftCorner,
    Point bottomRightCorner, {
    UUID,
    this.currentContext,
    this.prototypeNode,
  }) : super(topLeftCorner, bottomRightCorner, currentContext, UUID: UUID) {
    generator = PBTabGenerator();
  }

  @override
  void addChild(PBIntermediateNode node) {
    child = node;
  }

  @override
  String semanticName;

  @override
  PBEgg generatePluginNode(
      Point topLeftCorner, Point bottomRightCorner, DesignNode originalRef) {
    var tab = Tab(
      topLeftCorner,
      bottomRightCorner,
      currentContext: currentContext,
      UUID: Uuid().v4(),
      prototypeNode: PrototypeNode(originalRef?.prototypeNodeUUID),
    );
    if (originalRef is! AbstractGroupLayer) {
      var sketchNode = _convertWrapper(originalRef);

      ///Clean the node so that it doesn't get interpreted as a plugin again.
      sketchNode.interpretNode(currentContext).then(tab.addChild);
    }

    return tab;
  }

  @override
  void alignChild() {}

  @override
  List<PBIntermediateNode> layoutInstruction(List<PBIntermediateNode> layer) {
    return layer;
  }

  DesignNode _convertWrapper(DesignNode node) {
    /// This is for plugins
    var str = '${node.name}';
    node.name = str.replaceAll(RegExp(r'\.\*'), '');

    ///This is for symbol master
    if (node is SymbolMaster) {
      /// Convert to AbstractGroup?

    }

    ///This is for symbol Instance
    if (node is SymbolInstance) {}
    return node;
  }

  @override
  void extractInformation(DesignNode incomingNode) {
    // TODO: implement extractInformation
  }
}

class PBTabGenerator extends PBGenerator {
  PBTabGenerator() : super('Tab');

  @override
  String generate(PBIntermediateNode source) {
    if (source is Tab) {
      if (source.child != null) {}
      var buffer = StringBuffer();
      buffer.write('BottomNavigationBarItem(');
      buffer.write(source.child != null
          ? 'icon: ${manager.generate(source.child, type: BUILDER_TYPE.BODY)}'
          : '');
      buffer.write(')');
      return buffer.toString();
    }
  }
}
