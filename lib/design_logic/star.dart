import 'package:json_annotation/json_annotation.dart';
import 'package:parabeac_core/design_logic/design_shape.dart';

part 'star.g.dart';

@JsonSerializable()
class Star extends DesignShape {
  Star();
  factory Star.fromJson(Map<String, dynamic> json) => _$StarFromJson(json);
  Map<String, dynamic> toJson() => _$StarToJson(this);
}
