import 'package:parabeac_core/generation/generators/pb_generator.dart';
import 'package:parabeac_core/generation/generators/plugins/pb_plugin_node.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/injected_container.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/interfaces/pb_inherited_intermediate.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/interfaces/pb_injected_intermediate.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_layout_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/align_strategy.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/child_strategy.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_context.dart';
import 'dart:math';

import 'package:parabeac_core/interpret_and_optimize/helpers/pb_intermediate_node_tree.dart';

class InjectedAppbar extends PBEgg implements PBInjectedIntermediate {
  @override
  String semanticName = '<navbar>';

  /// String representing what the <leading> tag maps to
  final LEADING_ATTR_NAME = 'leading';

  /// String representing what the <middle> tag maps to
  final MIDDLE_ATTR_NAME = 'title';

  /// String representing what the <middle> tag maps to
  final TRAILING_ATTR_NAME = 'actions';

  // PBIntermediateNode get leadingItem => getAttributeNamed('leading');
  // PBIntermediateNode get middleItem => getAttributeNamed('title');
  // PBIntermediateNode get trailingItem => getAttributeNamed('actions');

  InjectedAppbar(
    String UUID,
    Rectangle frame,
    String name,
  ) : super(UUID, frame, name) {
    generator = PBAppBarGenerator();
    childrenStrategy = MultipleChildStrategy('children');
  }

  @override
  String getAttributeNameOf(PBIntermediateNode node) {
    if (node is PBIntermediateNode) {
      if (node.name.contains('<leading>')) {
        return LEADING_ATTR_NAME;
      }
      if (node.name.contains('<trailing>')) {
        return TRAILING_ATTR_NAME;
      }
      if (node.name.contains('<middle>')) {
        return MIDDLE_ATTR_NAME;
      }
    }

    return super.getAttributeNameOf(node);
  }

  @override
  PBEgg generatePluginNode(Rectangle frame, PBIntermediateNode originalRef,
      PBIntermediateTree tree) {
    var appbar = InjectedAppbar(
      originalRef.UUID,
      frame,
      originalRef.name,
    );

    tree
        .childrenOf(appbar)
        .forEach((child) => child.attributeName = getAttributeNameOf(child));

    return appbar;
  }

  @override
  void handleChildren(PBContext context) {
    var children = context.tree.childrenOf(this);

    // Remove children that have an invalid `attributeName`
    var validChildren = children.where(_isValidNode).toList();

    context.tree.replaceChildrenOf(this, validChildren);
  }

  /// Returns [true] if `node` has a valid `attributeName` in the eyes of the [InjectedAppbar].
  /// Returns [false] otherwise.
  bool _isValidNode(PBIntermediateNode node) {
    var validNames = [LEADING_ATTR_NAME, MIDDLE_ATTR_NAME, TRAILING_ATTR_NAME];

    return validNames.any((name) => name == node.attributeName);
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
    // generatorContext.sizingContext = SizingValueContext.PointValue;
    if (source is InjectedAppbar) {
      var buffer = StringBuffer();

      buffer.write('AppBar(');

      var actions = generatorContext.tree
          .childrenOf(source)
          .where((child) => child.attributeName == source.TRAILING_ATTR_NAME);
      var children = generatorContext.tree
          .childrenOf(source)
          .where((child) => child.attributeName != source.TRAILING_ATTR_NAME);

      // [actions] require special handling due to being a list
      if (actions.isNotEmpty) {
        buffer.write(
            '${source.TRAILING_ATTR_NAME}: ${_getActions(actions, generatorContext)},');
      }
      children.forEach((child) => buffer.write(
          '${child.attributeName}: ${_wrapOnIconButton(child.generator.generate(child, generatorContext))},'));

      buffer.write(')');
      return buffer.toString();
    }
  }

  /// Returns list ot `actions` as individual [PBIntermediateNodes]
  String _getActions(Iterable<PBIntermediateNode> actions, PBContext context) {
    var buffer = StringBuffer();

    buffer.write('[');
    actions.forEach((action) => buffer.write(
        '${_wrapOnIconButton(action.generator.generate(action, context))},'));
    buffer.write(']');

    return buffer.toString();
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
