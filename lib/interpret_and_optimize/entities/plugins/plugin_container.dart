import 'package:json_annotation/json_annotation.dart';
import 'package:parabeac_core/design_logic/design_node.dart';
import 'package:parabeac_core/generation/generators/plugins/pb_plugin_node.dart';
import 'package:parabeac_core/generation/generators/visual-widgets/pb_container_gen.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/injected_align.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/layouts/temp_group_layout_node.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_visual_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_context.dart';
import 'package:parabeac_core/interpret_and_optimize/value_objects/point.dart';

part 'plugin_container.g.dart';

@JsonSerializable(nullable: true)
class PluginContainer extends PBVisualIntermediateNode implements PBEgg {
  @override
  Point bottomRightCorner;

  @override
  String semanticName;

  @override
  String subsemantic;

  @override
  Point topLeftCorner;

  /// Used for setting the alignment of it's children
  double alignX;
  double alignY;

  @override
  final String color;

  @override
  final String UUID;

  @override
  @JsonKey(ignore: true)
  PBContext currentContext;

  var child;
  Map size;
  Map margins;
  Map padding;
  Map borderInfo;
  Map alignment;

  String widgetType = 'CONTAINER';

  PluginContainer(
    Point topLeftCorner,
    Point bottomRightCorner,
    this.UUID, {
    this.alignX,
    this.alignY,
    this.color,
    this.currentContext,
  }) : super(topLeftCorner, bottomRightCorner, currentContext) {
    generator = PBContainerGenerator();
    size = {
      'width': (bottomRightCorner.x - topLeftCorner.x).abs(),
      'height': (bottomRightCorner.y - topLeftCorner.y).abs(),
    };
    alignment = alignX != null && alignY != null
        ? {'alignX': alignX, 'alignY': alignY}
        : null;
  }

  @override
  void addChild(PBIntermediateNode node) {
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
    }
    child = node;
  }

  @override
  PBEgg generatePluginNode(
      Point topLeftCorner, Point bottomRightCorner, var originalRef) {
    return PluginContainer(topLeftCorner, bottomRightCorner, UUID,
        currentContext: currentContext);
  }

  @override
  List<PBIntermediateNode> layoutInstruction(List<PBIntermediateNode> layer) {
    // TODO: implement layoutInstruction
    return null;
  }

  @override
  void alignChild() {
    var align = InjectedAlign(topLeftCorner, bottomRightCorner, currentContext);
    align.addChild(child);
    align.alignChild();
    child = align;
  }

  factory PluginContainer.fromJson(Map<String, Object> json) =>
      _$PluginContainerFromJson(json);
  Map<String, Object> toJson() {
    alignment = alignX != null && alignY != null
        ? {'alignX': alignX, 'alignY': alignY}
        : null;
    return _$PluginContainerToJson(this);
  }

  @override
  void extractInformation(DesignNode incomingNode) {
    // TODO: implement extractInformation
  }
}
