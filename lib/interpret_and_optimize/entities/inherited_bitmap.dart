import 'dart:math';

import 'package:parabeac_core/controllers/main_info.dart';
import 'package:parabeac_core/design_logic/design_node.dart';
import 'package:parabeac_core/design_logic/image.dart';
import 'package:parabeac_core/generation/generators/visual-widgets/pb_bitmap_gen.dart';
import 'package:parabeac_core/generation/prototyping/pb_prototype_node.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/interfaces/pb_inherited_intermediate.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_constraints.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_visual_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/align_strategy.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/child_strategy.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_context.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_image_reference_storage.dart';
// import 'dart:math';
import 'package:quick_log/quick_log.dart';

class InheritedBitmap extends PBVisualIntermediateNode
    implements PBInheritedIntermediate {
  @override
  final originalRef;

  @override
  PrototypeNode prototypeNode;

  @override
  ChildrenStrategy childrenStrategy = NoChildStrategy();


  String referenceImage;

  InheritedBitmap(this.originalRef, String name,
      {PBContext currentContext,
      this.referenceImage,
      PBIntermediateConstraints constraints})
      : super(
            Point(originalRef.boundaryRectangle.x,
                originalRef.boundaryRectangle.y),
            Point(
                originalRef.boundaryRectangle.x +
                    originalRef.boundaryRectangle.width,
                originalRef.boundaryRectangle.y +
                    originalRef.boundaryRectangle.height),
            currentContext,
            name,
            UUID: originalRef.UUID ?? '',
            constraints: constraints) {
    if (originalRef is DesignNode && originalRef.prototypeNodeUUID != null) {
      prototypeNode = PrototypeNode(originalRef?.prototypeNodeUUID);
    }
    generator = PBBitmapGenerator();

    if (originalRef.name == null ||
        (originalRef as Image).imageReference == null) {
      logger.debug('NULL BITMAP');
    }
    name = (originalRef as Image).imageReference;
    size = {
      'width': originalRef.boundaryRectangle.width,
      'height': originalRef.boundaryRectangle.height
    };
    referenceImage = (originalRef as Image).imageReference;
    ImageReferenceStorage().addReference(
        originalRef.UUID, '${MainInfo().outputPath}assets/images');
  }

}
