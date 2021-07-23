import 'package:parabeac_core/design_logic/color.dart';
import 'package:parabeac_core/design_logic/design_node.dart';
import 'package:parabeac_core/eggs/injected_app_bar.dart';
import 'package:parabeac_core/eggs/injected_tab_bar.dart';
import 'package:parabeac_core/generation/generators/layouts/pb_scaffold_gen.dart';
import 'package:parabeac_core/generation/prototyping/pb_prototype_node.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/alignments/injected_align.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/layouts/temp_group_layout_node.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/pb_shared_instance.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_attribute.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_visual_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/abstract_intermediate_node_factory.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_context.dart';
import 'package:parabeac_core/interpret_and_optimize/value_objects/point.dart';
import 'interfaces/pb_inherited_intermediate.dart';
import 'package:json_annotation/json_annotation.dart';

part 'inherited_scaffold.g.dart';

@JsonSerializable()
class InheritedScaffold extends PBVisualIntermediateNode
    with
        PBColorMixin
    implements
        /* with GeneratePBTree */ /* PropertySearchable,*/ PBInheritedIntermediate,
        IntermediateNodeFactory {
  @override
  @JsonKey(fromJson: PrototypeNode.prototypeNodeFromJson)
  PrototypeNode prototypeNode;

  @JsonKey(defaultValue: false)
  bool isHomeScreen = false;

  @override
  @JsonKey(fromJson: Point.topLeftFromJson)
  Point topLeftCorner;
  @override
  @JsonKey(fromJson: Point.bottomRightFromJson)
  Point bottomRightCorner;

  @override
  @JsonKey()
  String type = 'inherited_scaffold';

  @override
  String UUID;

  @override
  @JsonKey(fromJson: PBIntermediateNode.sizeFromJson)
  Map size;

  @override
  @JsonKey(ignore: true)
  PBContext currentContext;

  @override
  PBIntermediateNode get child => getAttributeNamed('body')?.attributeNode;

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

  InheritedScaffold({
    this.topLeftCorner,
    this.bottomRightCorner,
    String name,
    this.currentContext,
    this.isHomeScreen,
    this.UUID,
    this.prototypeNode,
    this.size,
    this.type,
  }) : super(
          topLeftCorner,
          bottomRightCorner,
          currentContext,
          name,
          UUID: UUID ?? '',
        ) {
    // if (originalRef is DesignNode && originalRef.prototypeNodeUUID != null) {
    //   prototypeNode = PrototypeNode(originalRef?.prototypeNodeUUID);
    // }
    this.name = name
        ?.replaceAll(RegExp(r'[\W]'), '')
        ?.replaceFirst(RegExp(r'^([\d]|_)+'), '');

    generator = PBScaffoldGenerator();

    // auxiliaryData.color = toHex(originalRef.backgroundColor);

    // Add body attribute
    addAttribute(PBAttribute('body'));
  }

  @override
  List<PBIntermediateNode> layoutInstruction(List<PBIntermediateNode> layer) {
    return layer;
  }

  @override
  void addChild(PBIntermediateNode node) {
    if (node is PBSharedInstanceIntermediateNode) {
      if (node.originalRef.name.contains('<navbar>')) {
        addAttribute(PBAttribute('appBar', attributeNodes: [node]));
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
      return;
    }
    if (node is InjectedTabBar) {
      addAttribute(PBAttribute('bottomNavigationBar', attributeNodes: [node]));
      return;
    }

    if (child is TempGroupLayoutNode) {
      child.addChild(node);
      return;
    }
    // If there's multiple children add a temp group so that layout service lays the children out.
    if (child != null) {
      var temp = TempGroupLayoutNode(null, currentContext, node.name);
      temp.addChild(child);
      temp.addChild(node);
      child = temp;
    } else {
      child = node;
    }
  }

  @override
  void alignChild() {
    if (child != null) {
      var align =
          InjectedAlign(topLeftCorner, bottomRightCorner, currentContext, '');
      align.addChild(child);
      align.alignChild();
      child = align;
    }
  }

  @override
  PBIntermediateNode fromJson(Map<String, dynamic> json) =>
      _$InheritedScaffoldFromJson(json);
}
