import 'package:parabeac_core/design_logic/design_node.dart';
import 'package:parabeac_core/generation/generators/pb_generator.dart';
import 'package:parabeac_core/generation/generators/plugins/pb_plugin_node.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/interfaces/pb_injected_intermediate.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/align_strategy.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/child_strategy.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_context.dart';
import 'dart:math';

class InjectedBackArrow extends PBEgg implements PBInjectedIntermediate {

  @override
  String semanticName = '<back-arrow>';
  
  @override
  ChildrenStrategy childrenStrategy = NoChildStrategy();

  @override
  AlignStrategy alignStrategy = NoAlignment();

  InjectedBackArrow(
      Point topLeftCorner, Point bottomRightCorner, String UUID, String name,
      {PBContext currentContext})
      : super(topLeftCorner, bottomRightCorner, currentContext, name) {
    generator = PBBackArrowGenerator();
  }


  @override
  void extractInformation(DesignNode incomingNode) {}

  @override
  PBEgg generatePluginNode(
      Point topLeftCorner, Point bottomRightCorner, DesignNode originalRef) {
    return InjectedBackArrow(
        topLeftCorner, bottomRightCorner, UUID, originalRef.name,
        currentContext: currentContext);
  }
}

class PBBackArrowGenerator extends PBGenerator {
  PBBackArrowGenerator() : super();

  @override
  String generate(PBIntermediateNode source, PBContext generatorContext) {
    if (source is InjectedBackArrow) {
      return 'BackButton()';
    }
  }
}
