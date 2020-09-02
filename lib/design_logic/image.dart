import 'package:json_annotation/json_annotation.dart';
import 'package:parabeac_core/design_logic/design_element.dart';

import 'design_node.dart';

part 'image.g.dart';

@JsonSerializable()
class Image extends DesignElement {
  Image(
    this.imageReference,
    var designNode,
  ) : super(designNode);

  String imageReference;

  factory Image.fromJson(Map<String, dynamic> json) => _$ImageFromJson(json);
  Map<String, dynamic> toJson() => _$ImageToJson(this);
}
