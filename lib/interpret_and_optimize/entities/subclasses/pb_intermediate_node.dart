import 'package:parabeac_core/generation/generators/pb_flutter_generator.dart';
import 'package:parabeac_core/generation/generators/pb_generator.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_context.dart';
import 'package:parabeac_core/interpret_and_optimize/value_objects/point.dart';

import 'package:json_annotation/json_annotation.dart';

/// PB’s  representation of the intermediate representation for a sketch node.
/// Usually, we work with its subclasses. We normalize several aspects of data that a sketch node presents in order to work better at the intermediate level.
/// Sometimes, PBNode’s do not have a direct representation of a sketch node. For example, most layout nodes are primarily made through and understanding of a need for a layout.
@JsonSerializable(nullable: true)
abstract class PBIntermediateNode {
  /// A subsemantic is contextual info to be analyzed in or in-between the visual generation & layout generation services.
  String subsemantic;

  @JsonKey(ignore: true)
  BUILDER_TYPE builder_type;

  String widgetType;

  @JsonKey(ignore: true)
  PBGenerator generator;

  final String UUID;
  var child;

  Point topLeftCorner;
  Point bottomRightCorner;

  @JsonKey(ignore: true)
  PBContext currentContext;

  String color;
  Map size;
  Map borderInfo;
  Map alignment;

  String name;

  PBIntermediateNode(
      this.topLeftCorner, this.bottomRightCorner, this.UUID, this.name,
      {this.currentContext, this.subsemantic}) {
    if (topLeftCorner != null && bottomRightCorner != null) {
      assert(topLeftCorner.x <= bottomRightCorner.x &&
          topLeftCorner.y <= bottomRightCorner.y);
    }
  }

  /// Adds child to node.
  void addChild(PBIntermediateNode node);

  Map<String, dynamic> toJson() {
    return {};
  }
}

abstract class ChildrenListener {
  ///the [convertedChildren] are updated. Used for subclasses that need their convertedChildren information
  ///in order to assign some of their attributes. Left
  void childrenUpdated();
}
