import 'dart:math';
import 'package:parabeac_core/eggs/injected_app_bar.dart';
import 'package:parabeac_core/eggs/injected_tab_bar.dart';
import 'package:parabeac_core/generation/generators/layouts/pb_scaffold_gen.dart';
import 'package:parabeac_core/generation/prototyping/pb_prototype_node.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/interfaces/pb_inherited_intermediate.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/layouts/group.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_constraints.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_visual_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/abstract_intermediate_node_factory.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/child_strategy.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_context.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_intermediate_node_tree.dart';
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

  // PBIntermediateNode get navbar => getAttributeNamed('appBar');

  // PBIntermediateNode get tabbar => getAttributeNamed('bottomNavigationBar');

  @override
  Map<String, dynamic> originalRef;

  InheritedScaffold(
      String UUID, Rectangle<num> frame, String name, this.originalRef,
      {this.isHomeScreen, this.prototypeNode})
      : super(UUID, frame, name) {
    generator = PBScaffoldGenerator();
    childrenStrategy = MultipleChildStrategy('body');
  }

  @override
  String getAttributeNameOf(PBIntermediateNode node) {
    if (node is InjectedAppbar) {
      return 'appBar';
    } else if (node is InjectedTabBar) {
      return 'tabBar';
    }
    return super.getAttributeNameOf(node);
  }

  @override
  void handleChildren(PBContext context) {
    var children = getAllAtrributeNamed(context.tree, 'body');
    // Top-most stack should have scaffold's frame to align children properly
    var groupAtt = Group(null, frame)
      ..name = '$name-Group'
      ..attributeName = 'body'
      ..parent = this;
    context.tree.addEdges(groupAtt, children.map((child) => child).toList());

    // Keep appbar and tabbar
    var appBar = getAttributeNamed(context.tree, 'appBar');
    var tabBar = getAttributeNamed(context.tree, 'bottomNavigationBar');

    context.tree.replaceChildrenOf(this,
        [groupAtt, appBar, tabBar]..removeWhere((element) => element == null));
  }

  List<PBIntermediateNode> layoutInstruction(List<PBIntermediateNode> layer) {
    return layer;
  }

  static PBIntermediateNode fromJson(Map<String, dynamic> json) {
    var artboard = _$InheritedScaffoldFromJson(json)..originalRef = json;

    //Map artboard children by calling `addChild` method
    // artboard.mapRawChildren(json);
    return artboard;
  }

  @override
  PBIntermediateNode createIntermediateNode(Map<String, dynamic> json,
          PBIntermediateNode parent, PBIntermediateTree tree) =>
      InheritedScaffold.fromJson(json)..mapRawChildren(json, tree);

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


