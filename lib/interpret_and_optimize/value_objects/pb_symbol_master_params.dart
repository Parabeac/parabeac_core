import 'package:json_annotation/json_annotation.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/interfaces/pb_injected_intermediate.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_visual_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_context.dart';
import 'package:parabeac_core/interpret_and_optimize/value_objects/point.dart';

///TODO: Need another class for elements that generate but are not visuals.

class PBSymbolMasterParameter extends PBVisualIntermediateNode
    implements PBInjectedIntermediate {
  final Type type;
  final String parameterID;
  final bool canOverride;
  final String propertyName;
  final parameterDefinition;
  double topLeftX, topLeftY, bottomRightX, bottomRightY;

  PBContext context;

  PBSymbolMasterParameter(
      String name,
      this.type,
      this.parameterID,
      this.canOverride,
      this.propertyName,
      this.parameterDefinition,
      this.topLeftX,
      this.topLeftY,
      this.bottomRightX,
      this.bottomRightY,
      {this.context})
      : super(Point(0, 0), Point(0, 0), context, name);

  static String _typeToJson(type) {
    return type.toString();
  }

  static Type _typeFromJson(jsonType) {
    //TODO: return a more specified Type
    return PBIntermediateNode;
  }

  @override
  void addChild(PBIntermediateNode node) {}

  @override
  void alignChild() {}
}
