import 'package:parabeac_core/generation/generators/attribute-helper/pb_color_gen_helper.dart';
import 'package:parabeac_core/generation/generators/pb_generator.dart';
import 'package:parabeac_core/generation/generators/plugins/pb_plugin_node.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/interfaces/pb_injected_intermediate.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/child_strategy.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_context.dart';
import 'dart:math';

import 'package:parabeac_core/interpret_and_optimize/helpers/pb_intermediate_node_tree.dart';

class InjectedAppbar extends PBEgg implements PBInjectedIntermediate {
  @override
  String semanticName = '<navbar>';

  /// String representing what the <leading> tag maps to
  static final LEADING_ATTR_NAME = 'leading';

  /// String representing what the <middle> tag maps to
  static final MIDDLE_ATTR_NAME = 'title';

  /// String representing what the <trailing> tag maps to
  static final TRAILING_ATTR_NAME = 'actions';

  /// String representing what the <background> tag maps to
  static final BACKGROUND_ATTR_NAME = 'background';

  final tagToName = {
    '<leading>': LEADING_ATTR_NAME,
    '<middle>': MIDDLE_ATTR_NAME,
    '<trailing>': TRAILING_ATTR_NAME,
    '<background>': BACKGROUND_ATTR_NAME
  };

  InjectedAppbar(
    String UUID,
    Rectangle3D frame,
    String name,
  ) : super(UUID, frame, name) {
    generator = PBAppBarGenerator();
    childrenStrategy = MultipleChildStrategy('children');
  }

  @override
  String getAttributeNameOf(PBIntermediateNode node) {
    if (node is PBIntermediateNode) {
      /// Iterate `keys` of [tagToName] to see if
      /// any `key` matches [node.name]
      for (var key in tagToName.keys) {
        if (node.name.contains(key)) {
          return tagToName[key];
        }
      }
    }

    return super.getAttributeNameOf(node);
  }

  @override
  PBEgg generatePluginNode(Rectangle3D frame, PBIntermediateNode originalRef,
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
  bool _isValidNode(PBIntermediateNode node) =>
      tagToName.values.any((name) => name == node.attributeName);

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

      // Get necessary attributes that need to be processed separately
      var background = generatorContext.tree.childrenOf(source).firstWhere(
          (child) => child.attributeName == InjectedAppbar.BACKGROUND_ATTR_NAME,
          orElse: () => null);
      var actions = generatorContext.tree.childrenOf(source).where(
          (child) => child.attributeName == InjectedAppbar.TRAILING_ATTR_NAME);
      var children = generatorContext.tree.childrenOf(source).where((child) =>
          child.attributeName != InjectedAppbar.TRAILING_ATTR_NAME &&
          child.attributeName != InjectedAppbar.BACKGROUND_ATTR_NAME);

      if (background != null) {
        // TODO: PBColorGen may need a refactor in order to support `backgroundColor` when inside this tag
        buffer.write(
            'backgroundColor: Color(${background.auxiliaryData?.color?.toString()}),');
      }
      if (actions.isNotEmpty) {
        buffer.write(
            '${InjectedAppbar.TRAILING_ATTR_NAME}: ${_getActions(actions, generatorContext)},');
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
