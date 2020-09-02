import 'package:json_annotation/json_annotation.dart';
import 'package:parabeac_core/design_logic/design_element.dart';
import 'package:parabeac_core/design_logic/design_node.dart';

part 'text.g.dart';

@JsonSerializable()
class Text extends DesignElement {
  Text(
    this.content,
    var designNode,
  ) : super(designNode);

  String content;

  factory Text.fromJson(Map<String, dynamic> json) => _$TextFromJson(json);
  Map<String, dynamic> toJson() => _$TextToJson(this);
}
