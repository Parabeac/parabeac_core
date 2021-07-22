import 'package:parabeac_core/controllers/main_info.dart';
import 'package:parabeac_core/design_logic/design_node.dart';
import 'package:parabeac_core/design_logic/image.dart';
import 'package:parabeac_core/generation/generators/visual-widgets/pb_bitmap_gen.dart';
import 'package:parabeac_core/generation/prototyping/pb_prototype_node.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/interfaces/pb_inherited_intermediate.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_visual_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_context.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_image_reference_storage.dart';
import 'package:parabeac_core/interpret_and_optimize/value_objects/point.dart';
import 'package:quick_log/quick_log.dart';
import 'package:json_annotation/json_annotation.dart';

part 'inherited_bitmap.g.dart';

@JsonSerializable()
class InheritedBitmap extends PBVisualIntermediateNode
    implements PBInheritedIntermediate {
  @override
  @JsonKey(ignore: true)
  final originalRef;

  @override
  @JsonKey(fromJson: PrototypeNode.prototypeNodeFromJson)
  PrototypeNode prototypeNode;

  var log = Logger('Inherited Bitmap');

  @JsonKey(name: 'imageReference')
  String referenceImage;

  @override
  @JsonKey(fromJson: Point.topLeftFromJson)
  Point topLeftCorner;
  @override
  @JsonKey(fromJson: Point.bottomRightFromJson)
  Point bottomRightCorner;

  InheritedBitmap(
    this.originalRef,
    String name, {
    PBContext currentContext,
    this.referenceImage,
  }) : super(
            Point(originalRef.boundaryRectangle.x,
                originalRef.boundaryRectangle.y),
            Point(
                originalRef.boundaryRectangle.x +
                    originalRef.boundaryRectangle.width,
                originalRef.boundaryRectangle.y +
                    originalRef.boundaryRectangle.height),
            currentContext,
            name,
            UUID: originalRef.UUID ?? '') {
    if (originalRef is DesignNode && originalRef.prototypeNodeUUID != null) {
      prototypeNode = PrototypeNode(originalRef?.prototypeNodeUUID);
    }
    generator = PBBitmapGenerator();

    if (originalRef.name == null ||
        (originalRef as Image).imageReference == null) {
      log.debug('NULL BITMAP');
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

  @override
  void addChild(PBIntermediateNode node) {
    assert(true, 'Tried adding a child to InheritedBitmap.');
    return;
  }

  @override
  void alignChild() {
    return;
  }

  @override
  PBIntermediateNode fromJson(Map<String, dynamic> json) =>
      _$InheritedBitmapFromJson(json);
}
