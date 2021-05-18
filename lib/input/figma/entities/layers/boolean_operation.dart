import 'package:json_annotation/json_annotation.dart';
import 'package:parabeac_core/design_logic/group_node.dart';
import 'package:parabeac_core/design_logic/image.dart';
import 'package:parabeac_core/input/figma/entities/abstract_figma_node_factory.dart';
import 'package:parabeac_core/input/figma/entities/layers/vector.dart';
import 'package:parabeac_core/input/figma/entities/style/figma_style.dart';
import 'package:parabeac_core/input/figma/helper/figma_asset_processor.dart';
import 'package:parabeac_core/input/sketch/entities/objects/frame.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/inherited_bitmap.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_context.dart';
import 'package:quick_log/quick_log.dart';
import 'figma_node.dart';

part 'boolean_operation.g.dart';

@JsonSerializable(nullable: true)
class BooleanOperation extends FigmaVector
    implements FigmaNodeFactory, GroupNode, Image {
  @override
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
    String prototypeNodeUUID,
    num transitionDuration,
    String transitionEasing,
  }) : super(
            style: style,
            UUID: UUID,
            prototypeNodeUUID: prototypeNodeUUID,
            transitionDuration: transitionDuration,
            transitionEasing: transitionEasing) {
    log = Logger(runtimeType.toString());
    pbdfType = 'boolean_operation';
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
    imageReference = FigmaAssetProcessor().processImage(UUID);

    return Future.value(
        InheritedBitmap(this, name, currentContext: currentContext));
  }

  @override
  String imageReference;

  @override
  Map<String, dynamic> toPBDF() => toJson();

  @override
  String pbdfType = 'boolean_operation';
}
