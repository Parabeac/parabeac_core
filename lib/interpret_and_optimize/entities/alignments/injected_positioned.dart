import 'package:parabeac_core/generation/generators/visual-widgets/pb_positioned_gen.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/interfaces/pb_injected_intermediate.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_context.dart';
import 'package:parabeac_core/interpret_and_optimize/value_objects/point.dart';

class InjectedPositioned extends PBIntermediateNode
    implements PBInjectedIntermediate {
  final PositioningHolder positionedHolder;

  PBContext currentContext;

  final String UUID;

  double horizontalAlignValue, verticalAlignValue;
  String horizontalAlignType, verticalAlignType;

  double top, bottom, left, right = 0;

  InjectedPositioned(this.UUID, {this.positionedHolder, this.currentContext})
      : super(Point(0, 0), Point(0, 0), UUID, '',
            currentContext: currentContext) {
    top = positionedHolder.top;
    bottom = positionedHolder.bottom;
    left = positionedHolder.left;
    right = positionedHolder.right;
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
}

/// A object to help us communicate positioning type & value.
class PositioningHolder {
  double top;
  double bottom;
  double left;
  double right;
  HorizontalAlignType h_type;
  double h_value;
  VerticalAlignType v_type;
  double v_value;
}

enum HorizontalAlignType { left, right }

enum VerticalAlignType { top, bottom }
