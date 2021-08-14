import 'package:parabeac_core/generation/generators/pb_generator.dart';
import 'package:parabeac_core/generation/generators/plugins/pb_plugin_node.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/injected_container.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/interfaces/pb_inherited_intermediate.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/interfaces/pb_injected_intermediate.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/align_strategy.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_context.dart';
import 'dart:math';

class InjectedAppbar extends PBEgg implements PBInjectedIntermediate {
  @override
  String semanticName = '<navbar>';

  PBIntermediateNode get leadingItem => getAttributeNamed('leading');
  PBIntermediateNode get middleItem => getAttributeNamed('title');
  PBIntermediateNode get trailingItem => getAttributeNamed('actions');

  InjectedAppbar(
    String UUID,
    Rectangle frame,
    String name,
  ) : super(UUID, frame, name) {
    generator = PBAppBarGenerator();
    alignStrategy = CustomAppBarAlignment();
  }

  @override
  void addChild(PBIntermediateNode node) {
    if (node is PBInheritedIntermediate) {
      var attName = 'child';
      if (node.name.contains('<leading>')) {
        attName = 'leading';
      }
      if (node.name.contains('<trailing>')) {
        attName = 'actions';
      }
      if (node.name.contains('<middle>')) {
        attName = 'title';
      }
      node.attributeName = attName;
      children.add(node);
      return;
    }

    super.addChild(node);
  }

  @override
  PBEgg generatePluginNode(Rectangle frame, PBIntermediateNode originalRef) {
    var appbar = InjectedAppbar(
      originalRef.UUID,
      frame,
      originalRef.name,
    );

    originalRef.children.forEach(addChild);

    return appbar;
  }

  @override
  List<PBIntermediateNode> layoutInstruction(List<PBIntermediateNode> layer) {
    return layer;
  }

  @override
  void extractInformation(PBIntermediateNode incomingNode) {}
}

class CustomAppBarAlignment extends AlignStrategy<InjectedAppbar> {
  @override
  void align(PBContext context, InjectedAppbar node) {
    if (node.middleItem == null) {
      return;
    }

    /// This align only modifies middleItem
    var tempNode = InjectedContainer(
      node.middleItem.UUID,
      node.middleItem.frame,
      name: node.middleItem.name,
    )
      ..addChild(node.middleItem)
      ..attributeName = 'title';

    var target =
        node.children.firstWhere((element) => element.attributeName == 'title');
    target = tempNode;
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

      source.children.forEach((child) {
        buffer.write(
            '${child.attributeName}: ${_wrapOnBrackets(child.generator.generate(child, generatorContext), child == 'actions', child == 'leading')},');
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
