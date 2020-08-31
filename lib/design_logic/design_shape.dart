import 'package:json_annotation/json_annotation.dart';
import 'package:parabeac_core/design_logic/design_element.dart';

part 'design_shape.g.dart';

@JsonSerializable()
class DesignShape extends DesignElement {
  DesignShape() : super(null);
  factory DesignShape.fromJson(Map<String, dynamic> json) =>
      _$DesignShapeFromJson(json);
  Map<String, dynamic> toJson() => _$DesignShapeToJson(this);
}
