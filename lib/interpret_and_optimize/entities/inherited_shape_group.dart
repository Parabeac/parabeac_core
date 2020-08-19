import 'dart:io';
import 'dart:typed_data';

import 'package:parabeac_core/controllers/main_info.dart';
import 'package:parabeac_core/generation/generators/visual-widgets/pb_bitmap_gen.dart';
import 'package:parabeac_core/input/entities/layers/abstract_layer.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/interfaces/pb_inherited_intermediate.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_visual_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_context.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_image_reference_storage.dart';
import 'package:parabeac_core/interpret_and_optimize/value_objects/point.dart';
import 'package:json_annotation/json_annotation.dart';

part 'inherited_shape_group.g.dart';

@JsonSerializable(nullable: false)
class InheritedShapeGroup extends PBVisualIntermediateNode
    implements PBInheritedIntermediate {
  @override
  SketchNode originalRef;

  ///Represents the location of the png file.
  @JsonKey(ignore: true)
  Uint8List image;

  @override
  String UUID;

  ///Name of the png file
  String name;

  @JsonKey(ignore: true)
  PBContext currentContext;

  String referenceImage;

  Map size;

  String widgetType = 'ShapeGroup';

  InheritedShapeGroup(this.originalRef, {this.image, this.currentContext})
      : super(
            Point(originalRef.frame.x, originalRef.frame.y),
            Point(originalRef.frame.x + originalRef.frame.width,
                originalRef.frame.y + originalRef.frame.height),
            currentContext) {
    generator = PBBitmapGenerator();

    UUID = originalRef.do_objectID;

    size = {
      'width': originalRef.frame.width,
      'height': originalRef.frame.height
    };

    name = originalRef.name;

    ImageReferenceStorage().addReferenceAndWrite(
        name, '${MainInfo().outputPath}assets/images', image);
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
