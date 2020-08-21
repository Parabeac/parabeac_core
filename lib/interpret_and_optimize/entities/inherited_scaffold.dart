import 'package:parabeac_core/generation/generators/layouts/pb_scaffold_gen.dart';
import 'package:parabeac_core/input/entities/layers/abstract_layer.dart';
import 'package:parabeac_core/input/entities/layers/artboard.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/injected_align.dart';
import 'package:parabeac_core/plugins/injected_app_bar.dart';
import 'package:parabeac_core/plugins/injected_tab_bar.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/layouts/temp_group_layout_node.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/pb_shared_instance.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_visual_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_context.dart';
import 'package:parabeac_core/interpret_and_optimize/value_objects/point.dart';

import 'interfaces/pb_inherited_intermediate.dart';
import '../../generation/generators/plugins/pb_plugin_node.dart';

import 'package:json_annotation/json_annotation.dart';

part 'inherited_scaffold.g.dart';

@JsonSerializable(nullable: false)
class InheritedScaffold extends PBVisualIntermediateNode
    implements
        /* with GeneratePBTree */ /* PropertySearchable,*/ PBInheritedIntermediate {
  @override
  SketchNode originalRef;
  String name;
  @JsonSerializable(nullable: true)
  var navbar;
  @JsonSerializable(nullable: true)
  var tabbar;
  @JsonSerializable(nullable: true)
  String backgroundColor;

  @override
  String UUID;

  var body;

  @JsonKey(ignore: true)
  PBContext currentContext;

  InheritedScaffold(
    this.originalRef, {
    Point topLeftCorner,
    Point bottomRightCorner,
    this.name,
    this.currentContext,
  }) : super(
            Point(originalRef.frame.x, originalRef.frame.y),
            Point(originalRef.frame.x + originalRef.frame.width,
                originalRef.frame.y + originalRef.frame.height),
            currentContext) {
    this.name = name
        ?.replaceAll(RegExp(r'[\W]'), '')
        ?.replaceFirst(RegExp(r'^([\d]|_)+'), '');

    generator = PBScaffoldGenerator();

    this.currentContext.screenBottomRightCorner = Point(
        originalRef.frame.x + originalRef.frame.width,
        originalRef.frame.y + originalRef.frame.height);

    this.currentContext.screenTopLeftCorner =
        Point(originalRef.frame.x, originalRef.frame.y);

    UUID = originalRef.do_objectID;

    backgroundColor = (originalRef as Artboard).backgroundColor?.toHex();
  }

  @override
  List<PBIntermediateNode> layoutInstruction(List<PBIntermediateNode> layer) {
    return layer;
  }

  @override
  String semanticName;

  @override
  void addChild(PBIntermediateNode node) {
    if (node is PBSharedInstanceIntermediateNode) {
      if (node.originalRef.name.contains('.*navbar')) {
        navbar = node;
        return;
      }
      if (node.originalRef.name.contains('.*tabbar')) {
        tabbar = node;
        return;
      }
    }

    if (node is InjectedNavbar) {
      navbar = node;
      return;
    }
    if (node is InjectedTabBar) {
      tabbar = node;
      return;
    }

    if (child is TempGroupLayoutNode) {
      child.addChild(node);
      return;
    }
    // If there's multiple children add a temp group so that layout service lays the children out.
    if (child != null) {
      var temp = TempGroupLayoutNode(null, currentContext);
      temp.addChild(child);
      temp.addChild(node);
      child = temp;
    } else {
      child = node;
    }
  }

  @override
  void alignChild() {
    var align = InjectedAlign(topLeftCorner, bottomRightCorner, currentContext);
    align.addChild(child);
    align.alignChild();
    child = align;
  }

  // @override
  // PBNakedPluginNode generatePluginNode(
  //     Point topLeftCorner, Point bottomRightCorner, SketchNode originalRef) {
  //   return InheritedScaffold(originalRef,
  //       currentContext: currentContext,
  //       topLeftCorner: topLeftCorner,
  //       bottomRightCorner: bottomRightCorner);
  // }

  Map<String, Object> toJson() => _$InheritedScaffoldToJson(this);
  factory InheritedScaffold.fromJson(Map<String, Object> json) =>
      _$InheritedScaffoldFromJson(json);
}
