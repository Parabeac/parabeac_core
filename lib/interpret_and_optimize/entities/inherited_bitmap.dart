import 'package:parabeac_core/controllers/main_info.dart';
import 'package:parabeac_core/generation/generators/symbols/pb_mastersym_gen.dart';
import 'package:parabeac_core/generation/generators/visual-widgets/pb_bitmap_gen.dart';
import 'package:parabeac_core/input/entities/layers/abstract_layer.dart';
import 'package:parabeac_core/input/entities/layers/bitmap.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/interfaces/pb_inherited_intermediate.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_visual_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_context.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_image_reference_storage.dart';
import 'package:parabeac_core/interpret_and_optimize/value_objects/point.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:quick_log/quick_log.dart';

part 'inherited_bitmap.g.dart';

@JsonSerializable(nullable: false)
class InheritedBitmap extends PBVisualIntermediateNode
    implements PBInheritedIntermediate {
  @override
  final SketchNode originalRef;

  @override
  String UUID;

  @JsonKey(ignore: true)
  var log = Logger('Inherited Bitmap');

  String widgetType = 'Bitmap';

  @override
  @JsonKey(ignore: true)
  PBContext currentContext;

  String name;
  Map size;
  String referenceImage;

  InheritedBitmap(this.originalRef, {this.currentContext})
      : super(
            Point(originalRef.frame.x, originalRef.frame.y),
            Point(originalRef.frame.x + originalRef.frame.width,
                originalRef.frame.y + originalRef.frame.height),
            currentContext) {
    generator = PBBitmapGenerator();

    if (originalRef.name == null || (originalRef as Bitmap).image == null) {
      log.debug('NULL BITMAP');
    }
    UUID = originalRef.do_objectID;
    name = (originalRef as Bitmap).image.reference;
    size = {
      'width': originalRef.frame.width,
      'height': originalRef.frame.height
    };
    referenceImage = (originalRef as Bitmap).image.reference;
    ImageReferenceStorage().addReference(
        originalRef.do_objectID, '${MainInfo().outputPath}assets/images');
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

  factory InheritedBitmap.fromJson(Map<String, Object> json) =>
      _$InheritedBitmapFromJson(json);
  Map<String, Object> toJson() => _$InheritedBitmapToJson(this);
}
