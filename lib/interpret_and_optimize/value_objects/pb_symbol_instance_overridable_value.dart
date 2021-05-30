import 'package:json_annotation/json_annotation.dart';
import 'package:parabeac_core/generation/generators/util/pb_input_formatter.dart';
import 'package:parabeac_core/input/sketch/helper/symbol_node_mixin.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';

class PBSymbolInstanceOverridableValue {
  final Type type;

  final String UUID;
  final dynamic value;

  String get friendlyName => SN_UUIDtoVarName[UUID] ?? 'noname';

  PBSymbolInstanceOverridableValue(this.UUID, this.value, this.type);

  static String _typeToJson(type) {
    return {'Type': type.toString()}.toString();
  }

  static Type _typeFromJson(jsonType) {
    //TODO: return a more specified Type
    return PBIntermediateNode;
  }
}
