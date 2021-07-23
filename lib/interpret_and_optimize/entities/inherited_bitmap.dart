import 'package:parabeac_core/generation/generators/visual-widgets/pb_bitmap_gen.dart';
import 'package:parabeac_core/generation/prototyping/pb_prototype_node.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/interfaces/pb_inherited_intermediate.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_visual_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/abstract_intermediate_node_factory.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_context.dart';
import 'package:parabeac_core/interpret_and_optimize/value_objects/point.dart';
import 'package:quick_log/quick_log.dart';
import 'package:json_annotation/json_annotation.dart';

part 'inherited_bitmap.g.dart';

@JsonSerializable()
class InheritedBitmap extends PBVisualIntermediateNode
    implements PBInheritedIntermediate, IntermediateNodeFactory {
  @override
  @JsonKey(fromJson: PrototypeNode.prototypeNodeFromJson)
  PrototypeNode prototypeNode;

  @JsonKey(ignore: true)
  var log = Logger('Inherited Bitmap');

  @JsonKey(name: 'imageReference')
  String referenceImage;

  @override
  @JsonKey()
  String type = 'inherited_bitmap';

  @override
  @JsonKey(fromJson: Point.topLeftFromJson)
  Point topLeftCorner;
  @override
  @JsonKey(fromJson: Point.bottomRightFromJson)
  Point bottomRightCorner;

  @override
  String UUID;

  @override
  @JsonKey(fromJson: PBIntermediateNode.sizeFromJson)
  Map size;

  @override
  @JsonKey(ignore: true)
  PBContext currentContext;

  InheritedBitmap({
    String name,
    this.currentContext,
    this.referenceImage,
    this.bottomRightCorner,
    this.topLeftCorner,
    this.type,
    this.UUID,
    this.prototypeNode,
    this.size,
  }) : super(topLeftCorner, bottomRightCorner, currentContext, name,
            UUID: UUID ?? '') {
    // if (originalRef is DesignNode && originalRef.prototypeNodeUUID != null) {
    //   prototypeNode = PrototypeNode(originalRef?.prototypeNodeUUID);
    // }
    generator = PBBitmapGenerator();

    // if (originalRef.name == null ||
    //     (originalRef as Image).imageReference == null) {
    log.debug('NULL BITMAP');
    // }
    // name = (originalRef as Image).imageReference;
    // size = {
    //   'width': originalRef.boundaryRectangle.width,
    //   'height': originalRef.boundaryRectangle.height
    // };
    // referenceImage = (originalRef as Image).imageReference;
    // ImageReferenceStorage().addReference(
    //     originalRef.UUID, '${MainInfo().outputPath}assets/images');
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
