import 'dart:math';
import 'package:parabeac_core/design_logic/color.dart';
import 'package:parabeac_core/design_logic/design_node.dart';
import 'package:parabeac_core/eggs/injected_app_bar.dart';
import 'package:parabeac_core/eggs/injected_tab_bar.dart';
import 'package:parabeac_core/generation/generators/layouts/pb_scaffold_gen.dart';
import 'package:parabeac_core/generation/prototyping/pb_prototype_node.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/alignments/padding.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/layouts/stack.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/layouts/temp_group_layout_node.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/pb_shared_instance.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_attribute.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_visual_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/align_strategy.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_context.dart';


import 'interfaces/pb_inherited_intermediate.dart';

class InheritedScaffold extends PBVisualIntermediateNode
    with PBColorMixin
    implements PBInheritedIntermediate {
  @override
  var originalRef;
  @override
  PrototypeNode prototypeNode;

  bool isHomeScreen = false;

  @override
  AlignStrategy alignStrategy = NoAlignment();//PaddingAlignment();

  @override
  PBIntermediateNode get child => getAttributeNamed('body')?.attributeNode;

  @override
  List<PBIntermediateNode> get children => [child, navbar, tabbar];

  PBIntermediateNode get navbar => getAttributeNamed('appBar')?.attributeNode;

  PBIntermediateNode get tabbar =>
      getAttributeNamed('bottomNavigationBar')?.attributeNode;

  @override
  set child(PBIntermediateNode node) {
    if (!hasAttribute('body')) {
      addAttribute(PBAttribute('body', attributeNodes: [node]));
    } else {
      getAttributeNamed('body').attributeNode = node;
    }
  }

  InheritedScaffold(this.originalRef,
      {Point topLeftCorner,
      Point bottomRightCorner,
      String name,
      PBContext currentContext,
      this.isHomeScreen})
      : super(
            Point(originalRef.boundaryRectangle.x,
                originalRef.boundaryRectangle.y),
            Point(
                originalRef.boundaryRectangle.x +
                    originalRef.boundaryRectangle.width,
                originalRef.boundaryRectangle.y +
                    originalRef.boundaryRectangle.height),
            currentContext,
            name,
            UUID: originalRef.UUID ?? '') {
    if (originalRef is DesignNode && originalRef.prototypeNodeUUID != null) {
      prototypeNode = PrototypeNode(originalRef?.prototypeNodeUUID);
    }
    this.name = name
        ?.replaceAll(RegExp(r'[\W]'), '')
        ?.replaceFirst(RegExp(r'^([\d]|_)+'), '');

    generator = PBScaffoldGenerator();

    auxiliaryData.color = toHex(originalRef.backgroundColor);

    // Add body attribute
    addAttribute(PBAttribute('body'));
  }

  List<PBIntermediateNode> layoutInstruction(List<PBIntermediateNode> layer) {
    return layer;
  }

  @override
  void addChild( node) {
    if (node is PBSharedInstanceIntermediateNode) {
      if (node.originalRef.name.contains('<navbar>')) {
        addAttribute(PBAttribute('appBar', attributeNodes: [node]));
       currentContext.canvasTLC = Point(currentContext.canvasTLC.x,
          node.bottomRightCorner.y);
        return;
      }
      if (node.originalRef.name.contains('<tabbar>')) {
        addAttribute(
            PBAttribute('bottomNavigationBar', attributeNodes: [node]));
        return;
      }
    }

    if (node is InjectedAppbar) {
      addAttribute(PBAttribute('appBar', attributeNodes: [node]));
      currentContext.canvasTLC = Point(currentContext.canvasTLC.x,
          node.bottomRightCorner.y);
      return;
    }
    if (node is InjectedTabBar) {
      addAttribute(PBAttribute('bottomNavigationBar', attributeNodes: [node]));
      return;
    }

    if (child is TempGroupLayoutNode) {
      child.addChild(node);
      return;
    } else {
      if (child != null) {
        child.addChild(node);
      } else {
        var stack = PBIntermediateStackLayout(
         currentContext,
         name: node.name
        );
        stack.addChild(node);
        child = stack;
      }
    }
  }
}
