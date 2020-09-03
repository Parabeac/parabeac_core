import 'package:parabeac_core/design_logic/design_node.dart';
import 'package:parabeac_core/design_logic/group_node.dart';
import 'package:parabeac_core/design_logic/rect.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
// part 'artboard.g.dart';

// @JsonSerializable(nullable: false)
abstract class PBArtboard extends DesignNode implements GroupNode {
  var backgroundColor;
  PBArtboard(this.backgroundColor, UUID, String name, bool isVisible,
      Rect boundaryRectangle, String type, style)
      : super(UUID, name, isVisible, boundaryRectangle, type, style);

  // factory PBArtboard.fromJson(Map<String, dynamic> json) =>
  //     _$PBArtboardFromJson(json);
  // Map<String, dynamic> toJson() => _$PBArtboardToJson(this);

  @override
  List children;
}
