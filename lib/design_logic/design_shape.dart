import 'package:json_annotation/json_annotation.dart';
import 'package:parabeac_core/design_logic/design_element.dart';

@JsonSerializable()
abstract class DesignShape extends DesignElement {
  DesignShape() : super();
  // factory DesignShape.fromJson(Map<String, dynamic> json) =>
  //     _$DesignShapeFromJson(json);
  // Map<String, dynamic> toJson() => _$DesignShapeToJson(this);
}
