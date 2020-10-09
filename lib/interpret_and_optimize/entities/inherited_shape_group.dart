import 'dart:typed_data';

import 'package:parabeac_core/controllers/main_info.dart';
import 'package:parabeac_core/design_logic/design_node.dart';
import 'package:parabeac_core/generation/generators/visual-widgets/pb_bitmap_gen.dart';
import 'package:parabeac_core/generation/prototyping/pb_prototype_node.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/interfaces/pb_inherited_intermediate.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_visual_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_context.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_image_reference_storage.dart';
import 'package:parabeac_core/interpret_and_optimize/value_objects/point.dart';
import 'package:json_annotation/json_annotation.dart';

part 'inherited_shape_group.g.dart';

@JsonSerializable(nullable: true)
class InheritedShapeGroup extends PBVisualIntermediateNode
    implements PBInheritedIntermediate {
  @override
  var originalRef;

  @override
  @JsonKey(ignore: true)
  PrototypeNode prototypeNode;

  ///Represents the location of the png file.
  @JsonKey(ignore: true)
  Uint8List image;

  @override
  String UUID;

  @JsonKey(ignore: true)
  PBContext currentContext;

  String referenceImage;

  Map size;

  String widgetType = 'ShapeGroup';

  InheritedShapeGroup(this.originalRef, String name,
      {this.image, this.currentContext})
      : super(
            Point(originalRef.boundaryRectangle.x,
                originalRef.boundaryRectangle.y),
            Point(
                originalRef.boundaryRectangle.x +
                    originalRef.boundaryRectangle.width,
                originalRef.boundaryRectangle.y +
                    originalRef.boundaryRectangle.height),
            currentContext,
            name) {
    if (originalRef is DesignNode && originalRef.prototypeNodeUUID != null) {
      prototypeNode = PrototypeNode(originalRef?.prototypeNodeUUID);
    }
    generator = PBBitmapGenerator();

    UUID = originalRef.UUID;

    size = {
      'width': originalRef.boundaryRectangle.width,
      'height': originalRef.boundaryRectangle.height
    };

    name = originalRef.name;

    ImageReferenceStorage().addReferenceAndWrite(
        UUID, '${MainInfo().outputPath}assets/images', image);
  }

  @override
  void addChild(PBIntermediateNode node) => null;

  @override
  void alignChild() {
    // TODO: implement alignChild
  }

  factory InheritedShapeGroup.fromJson(Map<String, Object> json) =>
      _$InheritedShapeGroupFromJson(json);

  Map<String, Object> toJson() => _$InheritedShapeGroupToJson(this);
}
