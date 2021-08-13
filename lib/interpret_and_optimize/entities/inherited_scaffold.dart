import 'dart:math';
import 'package:parabeac_core/eggs/injected_app_bar.dart';
import 'package:parabeac_core/eggs/injected_tab_bar.dart';
import 'package:parabeac_core/generation/generators/layouts/pb_scaffold_gen.dart';
import 'package:parabeac_core/generation/prototyping/pb_prototype_node.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/alignments/padding.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/interfaces/pb_inherited_intermediate.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/layouts/stack.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/layouts/temp_group_layout_node.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/pb_shared_instance.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_constraints.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_visual_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/abstract_intermediate_node_factory.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/align_strategy.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_context.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_context.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:parabeac_core/interpret_and_optimize/state_management/intermediate_auxillary_data.dart';
import 'package:pbdl/pbdl.dart';

part 'inherited_scaffold.g.dart';

@JsonSerializable()
class InheritedScaffold extends PBVisualIntermediateNode
    with PBColorMixin
    implements PBInheritedIntermediate, IntermediateNodeFactory {
  @override
  @JsonKey(
      fromJson: PrototypeNode.prototypeNodeFromJson, name: 'prototypeNodeUUID')
  PrototypeNode prototypeNode;

  @JsonKey(defaultValue: false, name: 'isFlowHome')
  bool isHomeScreen = false;

  @override
  @JsonKey()
  String type = 'artboard';

  PBIntermediateNode get navbar => getAttributeNamed('appBar');

  PBIntermediateNode get tabbar => getAttributeNamed('bottomNavigationBar');

  @override
  Map<String, dynamic> originalRef;

  InheritedScaffold(
      String UUID, Rectangle<num> frame, String name, this.originalRef,
      {this.isHomeScreen, this.prototypeNode})
      : super(UUID, frame, name) {
    generator = PBScaffoldGenerator();
  }

  @override
  void addChild(PBIntermediateNode node) {
    // if (node is PBSharedInstanceIntermediateNode) {
    //   if (node.name.contains('<navbar>')) {
    //     // this.children.add();
    //     // addAttribute(PBAttribute('appBar', attributeNodes: [node]));
    //     // currentContext.canvasFrame = Rectangle.fromPoints(
    //     //     currentContext.screenFrame.topLeft, node.frame.bottomRight);
    //     return;
    //   }
    //   if (node.name.contains('<tabbar>')) {
    //     // addAttribute(
    //     //     PBAttribute('bottomNavigationBar', attributeNodes: [node]));
    //     return;
    //   }
    // }

    if (node is InjectedAppbar) {
      node.parent = this;
      children.add(node..attributeName = 'appBar');
      // currentContext.canvasFrame = Rectangle.fromPoints(
      //     currentContext.screenFrame.topLeft, node.frame.bottomRight);
      return;
    }
    if (node is InjectedTabBar) {
      node.parent = this;
      children.add(node..attributeName = 'bottomNavigationBar');
      // addAttribute(PBAttribute('bottomNavigationBar', attributeNodes: [node]));
      return;
    } else {
      node.parent = this;
      children.add(node..attributeName = 'body');
    }

    // if (child is TempGroupLayoutNode) {
    //   // child.addChild(node);
    //   return;
    // }
    // If there's multiple children add a temp group so that layout service lays the children out.
    // if (child != null) {
    // var temp = TempGroupLayoutNode(null, null,
    //     currentContext: currentContext, name: node.name);
    // temp.addChild(child);
    // temp.addChild(node);
    // child = temp;
    // } else {
    // if (child != null) {
    // child.addChild(node);
    // } else {
    // var stack = PBIntermediateStackLayout(currentContext,
    //     name: node.name,
    //     constraints: PBIntermediateConstraints(
    //         pinBottom: false,
    //         pinLeft: false,
    //         pinRight: false,
    //         pinTop: false));
    // var stack = TempGroupLayoutNode(UUID, frame);
    // stack.addChild(node);
    // child = stack;
    // }
  }

  @override
  void handleChildren(PBContext context) {
    var children = getAllAtrributeNamed('body');
    var groupAtt = TempGroupLayoutNode(null, null)
      ..attributeName = 'body'
      ..parent = this;
    children.forEach((att) => groupAtt.addChild(att));

    // Top-most stack should have scaffold's frame to align children properly
    groupAtt.frame = frame;

    this.children = [groupAtt];
  }

  List<PBIntermediateNode> layoutInstruction(List<PBIntermediateNode> layer) {
    return layer;
  }

  // }

  static PBIntermediateNode fromJson(Map<String, dynamic> json) {
    var artboard = _$InheritedScaffoldFromJson(json)..originalRef = json;

    //Map artboard children by calling `addChild` method
    artboard.mapRawChildren(json);
    return artboard;
  }

  @override
  PBIntermediateNode createIntermediateNode(Map<String, dynamic> json) =>
      InheritedScaffold.fromJson(json);

  // @override
  // set child(PBIntermediateNode node) {
  //   if (!hasAttribute('body')) {
  //     addAttribute(PBAttribute('body', attributeNodes: [node]));
  //   } else {
  //     getAttributeNamed('body').attributeNode = node;
  //   }
}

// InheritedScaffold(
//   String UUID,
//   Rectangle frame, {
//   this.originalRef,
//   String name,
//   this.isHomeScreen,
//   this.prototypeNode,
// }) : super(
//         UUID,
//         frame,
//         name,
//       ) {
//   this.name = name
//       ?.replaceAll(RegExp(r'[\W]'), '')
//       ?.replaceFirst(RegExp(r'^([\d]|_)+'), '');

//   generator = PBScaffoldGenerator();

//   //TODO switch to padding strategy

//   // Add body attribute
//   addAttribute(PBAttribute('body'));
// }


