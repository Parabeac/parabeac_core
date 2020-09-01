import 'dart:io';
import 'dart:typed_data';
import 'package:parabeac_core/controllers/main_info.dart';
import 'package:parabeac_core/design_logic/design_node.dart';
import 'package:parabeac_core/generation/generators/visual-widgets/pb_bitmap_gen.dart';
import 'package:parabeac_core/input/entities/layers/abstract_layer.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/inherited_shape_path.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/interfaces/pb_inherited_intermediate.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_visual_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_context.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_image_reference_storage.dart';
import 'package:parabeac_core/interpret_and_optimize/value_objects/point.dart';
import 'package:json_annotation/json_annotation.dart';

part 'inherited_oval.g.dart';

@JsonSerializable(nullable: false)
class InheritedOval extends PBVisualIntermediateNode
    implements PBInheritedIntermediate {
  @override
  DesignNode originalRef;

  ///Represents the location of the png file.
  @JsonKey(ignore: true)
  Uint8List image;

  ///Name of the png file
  String name;

  @override
  String UUID;

  @JsonKey(ignore: true)
  PBContext currentContext;

  Map size;

  String referenceImage;

  String widgetType = 'Bitmap';

  InheritedOval(this.originalRef, {this.image, this.currentContext})
      : super(
            Point(originalRef.boundaryRectangle.x,
                originalRef.boundaryRectangle.y),
            Point(
                originalRef.boundaryRectangle.x +
                    originalRef.boundaryRectangle.width,
                originalRef.boundaryRectangle.y +
                    originalRef.boundaryRectangle.height),
            currentContext) {
    generator = PBBitmapGenerator();

    size = {
      'width': originalRef.boundaryRectangle.width,
      'height': originalRef.boundaryRectangle.height
    };
    UUID = originalRef.UUID;

    name = originalRef.name;

    ImageReferenceStorage().addReferenceAndWrite(
        UUID, '${MainInfo().outputPath}assets/images', image);
  }

  @override
  void addChild(PBIntermediateNode node) {
    // Hopefully we converted the SVG correctly. Most likely this will get called to add the shapes but this is unnecessary.
    if (node is InheritedShapePath) {
      return;
    }
    assert(false,
        'Child with type ${node.runtimeType} could not be added as a child.');
    return;
  }

  @override
  void alignChild() {
    // TODO: implement alignChild
  }

  factory InheritedOval.fromJson(Map<String, Object> json) =>
      _$InheritedOvalFromJson(json);
  Map<String, Object> toJson() => _$InheritedOvalToJson(this);
}
