import 'package:parabeac_core/design_logic/design_node.dart';
import 'package:parabeac_core/generation/generators/visual-widgets/pb_container_gen.dart';
import 'package:parabeac_core/input/entities/layers/abstract_layer.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/injected_align.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/interfaces/pb_inherited_intermediate.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/layouts/temp_group_layout_node.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_visual_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_context.dart';
import 'package:parabeac_core/interpret_and_optimize/value_objects/point.dart';
import 'package:json_annotation/json_annotation.dart';

part 'inherited_container.g.dart';

@JsonSerializable(nullable: false)
class InheritedContainer extends PBVisualIntermediateNode
    implements PBInheritedIntermediate {
  @override
  final originalRef;

  @override
  final Point bottomRightCorner;

  @override
  final Point topLeftCorner;

  @JsonKey(ignore: true)
  PBContext currentContext;

  String widgetType = 'CONTAINER';

  @override
  String UUID; //TODO find the root cause of why certain node have a null UUID

  /// Used for setting the alignment of it's children
  @JsonKey(ignore: true)
  double alignX;
  @JsonKey(ignore: true)
  double alignY;

  Map size;

  Map alignment;

  @JsonKey(nullable: true)
  Map borderInfo;

  InheritedContainer(
      this.originalRef, this.topLeftCorner, this.bottomRightCorner,
      {this.alignX, this.alignY, this.currentContext, this.borderInfo})
      : super(topLeftCorner, bottomRightCorner, currentContext) {
    generator = PBContainerGenerator();

    borderInfo ??= {};
    UUID = originalRef.UUID ?? '';

    size = {
      'width': originalRef.boundaryRectangle.width,
      'height': originalRef.boundaryRectangle.height,
    };

    if (originalRef.style.fills.isNotEmpty) {
      for (var fill in originalRef.style.fills) {
        if (fill.isEnabled) {
          color = fill.color.toHex();
        }
      }
    }
    alignment = alignX != null && alignY != null
        ? {'alignX': alignX, 'alignY': alignY}
        : null;

    assert(originalRef != null,
        'A null original reference was sent to an PBInheritedIntermediate Node');
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

  /// Should add positional info ONLY to parent node. This should only be sent here if the parent and child node is only one-to-one.
  ///
  /// alignCenterX/y = ((childCenter - parentCenter) / max) if > 0.5 subtract 0.5 if less than 0.5 multiply times -1
  @override
  void alignChild() {
    var align = InjectedAlign(topLeftCorner, bottomRightCorner, currentContext);
    align.addChild(child);
    align.alignChild();
    child = align;
  }

  factory InheritedContainer.fromJson(Map<String, Object> json) =>
      _$InheritedContainerFromJson(json);
  Map<String, Object> toJson() => _$InheritedContainerToJson(this);
}
