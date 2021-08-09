import 'package:parabeac_core/generation/generators/pb_generator.dart';
import 'package:parabeac_core/generation/generators/plugins/pb_plugin_node.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/injected_container.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/interfaces/pb_inherited_intermediate.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/interfaces/pb_injected_intermediate.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/align_strategy.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_context.dart';
import 'dart:math';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_attribute.dart';

class InjectedAppbar extends PBEgg implements PBInjectedIntermediate {
  @override
  String semanticName = '<navbar>';

  @override
  AlignStrategy alignStrategy = CustomAppBarAlignment();

  @override
  List<PBIntermediateNode> get children =>
      [leadingItem, middleItem, trailingItem];

  PBIntermediateNode get leadingItem =>
      getAttributeNamed('leading')?.attributeNode;
  PBIntermediateNode get middleItem =>
      getAttributeNamed('title')?.attributeNode;
  PBIntermediateNode get trailingItem =>
      getAttributeNamed('actions')?.attributeNode;

  InjectedAppbar(
      Point topLeftCorner, Point bottomRightCorner, String UUID, String name,
      {PBContext currentContext})
      : super(topLeftCorner, bottomRightCorner, currentContext, name) {
    generator = PBAppBarGenerator();
    addAttribute(PBAttribute('leading'));
    addAttribute(PBAttribute('title'));
    addAttribute(PBAttribute('actions'));
  }

  @override
  void addChild(node) {
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
  PBEgg generatePluginNode(
      Point topLeftCorner, Point bottomRightCorner, originalRef) {
    return InjectedAppbar(
        topLeftCorner, bottomRightCorner, UUID, originalRef.name,
        currentContext: currentContext);
  }

  @override
  List<PBIntermediateNode> layoutInstruction(List<PBIntermediateNode> layer) {
    return layer;
  }

  @override
  void extractInformation(PBIntermediateNode incomingNode) {}
}
class CustomAppBarAlignment extends AlignStrategy<InjectedAppbar>{
  @override
  void align(PBContext context, InjectedAppbar node) {
     /// This align only modifies middleItem
    var tempNode = InjectedContainer(node.middleItem.bottomRightCorner,
        node.middleItem.topLeftCorner, node.middleItem.name, node.middleItem.UUID,
        currentContext: node.currentContext, constraints: node.middleItem.constraints)
      ..addChild(node.middleItem);

    node.getAttributeNamed('title').attributeNode = tempNode;
  }
}
class PBAppBarGenerator extends PBGenerator {
  PBAppBarGenerator() : super();

  @override
  String generate(PBIntermediateNode source, PBContext generatorContext) {
    // generatorContext.sizingContext = SizingValueContext.PointValue;
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
