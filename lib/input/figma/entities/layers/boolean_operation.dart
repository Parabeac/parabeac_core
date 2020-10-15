import 'package:json_annotation/json_annotation.dart';
import 'package:parabeac_core/design_logic/group_node.dart';
import 'package:parabeac_core/design_logic/image.dart';
import 'package:parabeac_core/input/figma/entities/abstract_figma_node_factory.dart';
import 'package:parabeac_core/input/figma/entities/layers/vector.dart';
import 'package:parabeac_core/input/figma/entities/style/figma_style.dart';
import 'package:parabeac_core/input/sketch/entities/objects/frame.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/inherited_bitmap.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_context.dart';
import 'package:quick_log/quick_log.dart';
import 'figma_node.dart';
import 'package:parabeac_core/input/figma/helper/image_helper.dart'
    as image_helper;

part 'boolean_operation.g.dart';

@JsonSerializable(nullable: true)
class BooleanOperation extends FigmaVector
    with image_helper.PBImageHelperMixin
    implements FigmaNodeFactory, GroupNode, Image {
  @JsonKey(ignore: true)
  Logger log;
  @override
  List children;
  String booleanOperation;

  @override
  String type = 'BOOLEAN_OPERATION';

  @override
  var boundaryRectangle;

  BooleanOperation({
    List<FigmaNode> this.children,
    booleanOperation,
    type,
    FigmaStyle style,
    Frame this.boundaryRectangle,
    String UUID,
  }) : super(
          style: style,
          UUID: UUID,
        ) {
    log = Logger(runtimeType.toString());
  }

  @override
  FigmaNode createFigmaNode(Map<String, dynamic> json) =>
      BooleanOperation.fromJson(json);
  factory BooleanOperation.fromJson(Map<String, dynamic> json) =>
      _$BooleanOperationFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$BooleanOperationToJson(this);

  @override
  Future<PBIntermediateNode> interpretNode(PBContext currentContext) async {
    imageReference = addToImageQueue(UUID);

    return Future.value(
        InheritedBitmap(this, name, currentContext: currentContext));
  }

  @override
  String imageReference;
}
