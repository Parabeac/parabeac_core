import 'package:json_annotation/json_annotation.dart';
import 'package:parabeac_core/design_logic/design_element.dart';
import 'package:parabeac_core/design_logic/design_node.dart';
import 'package:parabeac_core/design_logic/group_node.dart';

part 'artboard.g.dart';

@JsonSerializable(nullable: false)
class PBArtboard extends DesignElement implements GroupNode {
  var backgroundColor;
  PBArtboard(this.backgroundColor) : super(null);

  factory PBArtboard.fromJson(Map<String, dynamic> json) =>
      _$PBArtboardFromJson(json);
  Map<String, dynamic> toJson() => _$PBArtboardToJson(this);

  @override
  List<DesignNode> children;
}
