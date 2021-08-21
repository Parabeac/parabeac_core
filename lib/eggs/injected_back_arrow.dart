import 'package:parabeac_core/generation/generators/pb_generator.dart';
import 'package:parabeac_core/generation/generators/plugins/pb_plugin_node.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/interfaces/pb_injected_intermediate.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/align_strategy.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/child_strategy.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_context.dart';
import 'dart:math';

import 'package:parabeac_core/interpret_and_optimize/helpers/pb_intermediate_node_tree.dart';

class InjectedBackArrow extends PBEgg implements PBInjectedIntermediate {
  @override
  String semanticName = '<back-arrow>';

  @override
  ChildrenStrategy childrenStrategy = NoChildStrategy();

  @override
  AlignStrategy alignStrategy = NoAlignment();

  InjectedBackArrow(
    String UUID,
    Rectangle3D frame,
    String name,
  ) : super(UUID, frame, name) {
    generator = PBBackArrowGenerator();
  }

  @override
  void extractInformation(PBIntermediateNode incomingNode) {}

  @override
  PBEgg generatePluginNode(Rectangle3D frame, PBIntermediateNode originalRef,
      PBIntermediateTree tree) {
    return InjectedBackArrow(
      UUID,
      frame,
      originalRef.name,
    );
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
