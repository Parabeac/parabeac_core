import 'package:parabeac_core/design_logic/design_node.dart';
import 'package:parabeac_core/generation/generators/pb_generator.dart';
import 'package:parabeac_core/generation/prototyping/pb_prototype_node.dart';
import 'package:parabeac_core/input/sketch/entities/layers/abstract_group_layer.dart';
import 'package:parabeac_core/input/sketch/entities/layers/symbol_instance.dart';
import 'package:parabeac_core/input/sketch/entities/layers/symbol_master.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/interfaces/pb_injected_intermediate.dart';
import 'package:parabeac_core/generation/generators/plugins/pb_plugin_node.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/interfaces/pb_prototype_enabled.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_context.dart';
import 'package:parabeac_core/interpret_and_optimize/value_objects/point.dart';
import 'package:uuid/uuid.dart';

class Tab extends PBEgg implements PBInjectedIntermediate, PrototypeEnable {
  @override
  PrototypeNode prototypeNode;

  Tab(
    Point topLeftCorner,
    Point bottomRightCorner,
    String name, {
    UUID,
    PBContext currentContext,
    this.prototypeNode,
  }) : super(topLeftCorner, bottomRightCorner, currentContext, name,
            UUID: UUID) {
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
      originalRef.name,
      currentContext: currentContext,
      UUID: originalRef != null &&
              originalRef.UUID != null &&
              originalRef.UUID.isNotEmpty
          ? originalRef.UUID
          : Uuid().v4(),
      prototypeNode: PrototypeNode(originalRef?.prototypeNodeUUID),
    );
    if (originalRef is! AbstractGroupLayer) {
      var designNode = _convertWrapper(originalRef);

      ///Clean the node so that it doesn't get interpreted as a plugin again.
      designNode.interpretNode(currentContext).then(tab.addChild);
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
    node.name = str.replaceAll(RegExp(r'\<.*?\>'), '');

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
  PBTabGenerator() : super();

  @override
  String generate(PBIntermediateNode source, PBContext generatorContext) {
    if (source is Tab) {
      var buffer = StringBuffer();
      buffer.write('BottomNavigationBarItem(');
      buffer.write(source.child != null
          ? 'icon: ${source.child.generator.generate(source.child, generatorContext)}'
          : '');
      buffer.write(')');
      return buffer.toString();
    } else {
      return '';
    }
  }
}
