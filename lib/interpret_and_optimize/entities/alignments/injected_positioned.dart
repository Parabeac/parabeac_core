import 'package:parabeac_core/generation/generators/visual-widgets/pb_positioned_gen.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/interfaces/pb_injected_intermediate.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_context.dart';
import 'package:parabeac_core/interpret_and_optimize/value_objects/point.dart';
import 'package:json_annotation/json_annotation.dart';

part 'injected_positioned.g.dart';

@JsonSerializable(nullable: true)
class InjectedPositioned extends PBIntermediateNode
    implements PBInjectedIntermediate {
  @JsonKey(ignore: true)
  final PositioningHolder positionedHolder;
  @JsonKey(ignore: true)
  PBContext currentContext;
  var child;

  final String UUID;

  String widgetType = 'POSITIONED';

  double horizontalAlignValue, verticalAlignValue;
  String horizontalAlignType, verticalAlignType;

  InjectedPositioned(this.UUID, {this.positionedHolder, this.currentContext})
      : super(Point(0, 0), Point(0, 0), UUID, '',
            currentContext: currentContext) {
    horizontalAlignType = positionedHolder.h_type.toString()?.split('.')[1];
    verticalAlignType = positionedHolder.v_type.toString()?.split('.')[1];
    horizontalAlignValue = positionedHolder.h_value;
    verticalAlignValue = positionedHolder.v_value;
    generator = PBPositionedGenerator();
  }

  @override
  void addChild(PBIntermediateNode node) {
    assert(child == null,
        'Tried assigning multiple children to class [InjectedPositioned]');
    child = node;
  }

  factory InjectedPositioned.fromJson(Map<String, Object> json) =>
      _$InjectedPositionedFromJson(json);

  Map<String, Object> toJson() => _$InjectedPositionedToJson(this);
}

/// A object to help us communicate positioning type & value.
class PositioningHolder {
  HorizontalAlignType h_type;
  double h_value;
  VerticalAlignType v_type;
  double v_value;
}

enum HorizontalAlignType { left, right }

enum VerticalAlignType { top, bottom }
