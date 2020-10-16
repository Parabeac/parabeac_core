import 'package:json_annotation/json_annotation.dart';
import 'package:parabeac_core/design_logic/design_element.dart';
import 'package:json_annotation/json_annotation.dart';
@JsonSerializable()
abstract class DesignShape extends DesignElement {
  DesignShape() : super();
}
