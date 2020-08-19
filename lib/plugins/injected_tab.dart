import 'package:parabeac_core/generation/generators/pb_flutter_generator.dart';
import 'package:parabeac_core/generation/generators/pb_generator.dart';
import 'package:parabeac_core/generation/generators/pb_widget_manager.dart';
import 'package:parabeac_core/input/entities/layers/abstract_group_layer.dart';
import 'package:parabeac_core/input/entities/layers/abstract_layer.dart';
import 'package:parabeac_core/input/entities/layers/symbol_instance.dart';
import 'package:parabeac_core/input/entities/layers/symbol_master.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/interfaces/pb_injected_intermediate.dart';
import 'package:parabeac_core/generation/generators/plugins/pb_plugin_node.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_context.dart';
import 'package:parabeac_core/interpret_and_optimize/value_objects/point.dart';
import 'package:uuid/uuid.dart';

class Tab extends PBNakedPluginNode
    implements PBInjectedIntermediate {
  PBContext currentContext;

  String widgetType = 'Tab';

  Tab(
    Point topLeftCorner,
    Point bottomRightCorner, {
    UUID,
    this.currentContext,
  }) : super(topLeftCorner, bottomRightCorner, currentContext, UUID: UUID) {
    generator = PBTabGenerator(currentContext.generationManager);
  }

  @override
  void addChild(PBIntermediateNode node) {
    child = node;
  }

  @override
  String semanticName;

  @override
  PBNakedPluginNode generatePluginNode(
      Point topLeftCorner, Point bottomRightCorner, SketchNode originalRef) {
    var tab = Tab(topLeftCorner, bottomRightCorner,
        currentContext: currentContext, UUID: Uuid().v4());
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

  SketchNode _convertWrapper(SketchNode node) {
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
  void extractInformation(SketchNode incomingNode) {
    // TODO: implement extractInformation
  }
}
class PBTabGenerator extends PBGenerator {
  final PBGenerationManager manager;
  PBTabGenerator(this.manager) : super('Tab');

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