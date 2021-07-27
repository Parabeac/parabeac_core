import 'package:parabeac_core/generation/generators/pb_generator.dart';
import 'package:parabeac_core/generation/generators/plugins/pb_plugin_node.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/injected_container.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/interfaces/pb_inherited_intermediate.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/interfaces/pb_injected_intermediate.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_context.dart';
import 'package:parabeac_core/interpret_and_optimize/value_objects/point.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_attribute.dart';

class InjectedAppbar extends PBEgg implements PBInjectedIntermediate {
  @override
  PBContext currentContext;

  @override
  String semanticName = '<navbar>';

  @override
  String UUID;

  PBIntermediateNode get leadingItem =>
      getAttributeNamed('leading')?.attributeNode;
  PBIntermediateNode get middleItem =>
      getAttributeNamed('title')?.attributeNode;
  PBIntermediateNode get trailingItem =>
      getAttributeNamed('actions')?.attributeNode;

  InjectedAppbar(
      Point topLeftCorner, Point bottomRightCorner, this.UUID, String name,
      {this.currentContext})
      : super(topLeftCorner, bottomRightCorner, currentContext, name) {
    generator = PBAppBarGenerator();
    addAttribute(PBAttribute('leading'));
    addAttribute(PBAttribute('title'));
    addAttribute(PBAttribute('actions'));
  }

  @override
  void addChild(PBIntermediateNode node) {
    if (node is PBInheritedIntermediate) {
      if (node.name.contains('<leading>')) {
        getAttributeNamed('leading').attributeNode = node;
      }

      if (node.name.contains('<trailing>')) {
        getAttributeNamed('actions').attributeNode = node;
      }
      if (node.name.contains('<middle>')) {
        getAttributeNamed('title').attributeNode = node;
      }
    }

    return;
  }

  @override
  void alignChild() {
    /// This align only modifies middleItem
    var tempNode = InjectedContainer(
      bottomRightCorner: middleItem.bottomRightCorner,
      topLeftCorner: middleItem.topLeftCorner,
      name: middleItem.name,
      UUID: middleItem.UUID,
    )..addChild(middleItem);

    getAttributeNamed('title').attributeNode = tempNode;
  }

  @override
  PBEgg generatePluginNode(Point topLeftCorner, Point bottomRightCorner,
      PBIntermediateNode originalNode) {
    var appbar = InjectedAppbar(
      topLeftCorner,
      bottomRightCorner,
      UUID,
      originalNode.name,
      currentContext: currentContext,
    );
    originalNode.children?.forEach(appbar.addChild);
    return appbar;
  }

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
    generatorContext.sizingContext = SizingValueContext.PointValue;
    if (source is InjectedAppbar) {
      var buffer = StringBuffer();

      buffer.write('AppBar(');

      source.attributes.forEach((attribute) {
        attribute.attributeNode.currentContext = source.currentContext;
        buffer.write(
            '${attribute.attributeName}: ${_wrapOnBrackets(attribute.attributeNode.generator.generate(attribute.attributeNode, generatorContext), attribute.attributeName == 'actions', attribute.attributeName == 'leading')},');
      });

      buffer.write(')');
      return buffer.toString();
    }
  }

  String _wrapOnBrackets(String body, bool isActions, bool isLeading) {
    if (isActions) {
      return '[${_wrapOnIconButton(body)}]';
    } else if (isLeading) {
      return _wrapOnIconButton(body);
    }
    return '$body';
  }

  String _wrapOnIconButton(String body) {
    return ''' 
      IconButton(
        icon: $body,
        onPressed: () {
          // TODO: Fill action
        }
      )
    ''';
  }
}
