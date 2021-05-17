import 'package:json_annotation/json_annotation.dart';
import 'package:parabeac_core/design_logic/design_node.dart';
import 'package:parabeac_core/design_logic/image.dart';
import 'package:parabeac_core/input/figma/entities/abstract_figma_node_factory.dart';
import 'package:parabeac_core/input/figma/entities/layers/figma_node.dart';
import 'package:parabeac_core/input/figma/entities/layers/frame.dart';
import 'package:parabeac_core/input/figma/entities/layers/text.dart';
import 'package:parabeac_core/input/figma/entities/layers/vector.dart';
import 'package:parabeac_core/input/figma/entities/style/figma_color.dart';
import 'package:parabeac_core/input/figma/helper/figma_asset_processor.dart';
import 'package:parabeac_core/input/sketch/entities/objects/frame.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/inherited_bitmap.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/layouts/temp_group_layout_node.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_context.dart';
import 'package:parabeac_core/interpret_and_optimize/value_objects/point.dart';
import 'package:quick_log/quick_log.dart';

part 'group.g.dart';

@JsonSerializable(nullable: true)

/// Class that represents a Figma Group.
/// The reason this class implements Image is because Groups can hold multiple vectors
/// which we need to convert into images.
class Group extends FigmaFrame implements AbstractFigmaNodeFactory, Image {
  @JsonKey(ignore: true)
  Logger log;
  @override
  String type = 'GROUP';

  @override
  String imageReference;

  Group(
      {name,
      isVisible,
      type,
      pluginData,
      sharedPluginData,
      Frame boundaryRectangle,
      style,
      fills,
      strokes,
      strokeWeight,
      strokeAlign,
      cornerRadius,
      constraints,
      layoutAlign,
      size,
      horizontalPadding,
      verticalPadding,
      itemSpacing,
      List<FigmaNode> children,
      String UUID,
      FigmaColor backgroundColor,
      String prototypeNodeUUID,
      num transitionDuration,
      String transitionEasing})
      : super(
            name: name,
            isVisible: isVisible,
            type: type,
            pluginData: pluginData,
            sharedPluginData: sharedPluginData,
            boundaryRectangle: boundaryRectangle,
            style: style,
            fills: fills,
            strokes: strokes,
            strokeWeight: strokeWeight,
            strokeAlign: strokeAlign,
            cornerRadius: cornerRadius,
            constraints: constraints,
            layoutAlign: layoutAlign,
            size: size,
            horizontalPadding: horizontalPadding,
            verticalPadding: verticalPadding,
            itemSpacing: itemSpacing,
            children: children,
            UUID: UUID,
            backgroundColor: backgroundColor,
            prototypeNodeUUID: prototypeNodeUUID,
            transitionDuration: transitionDuration,
            transitionEasing: transitionEasing) {
    if (areAllVectors()) {
      pbdfType = 'image';
    } else {
      pbdfType = 'group';
    }
    log = Logger(runtimeType.toString());
  }

  @override
  FigmaNode createFigmaNode(Map<String, dynamic> json) => Group.fromJson(json);
  factory Group.fromJson(Map<String, dynamic> json) => _$GroupFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$GroupToJson(this);

  @override
  Future<PBIntermediateNode> interpretNode(PBContext currentContext) async {
    if (areAllVectors()) {
      imageReference = FigmaAssetProcessor().processImage(UUID);

      var tempPrototypeID = childrenHavePrototypeNode();
      if (tempPrototypeID != null) {
        prototypeNodeUUID = tempPrototypeID;
      }

      if (children != null && children.isNotEmpty) {
        boundaryRectangle = fitFrame();
      }

      children.clear();

      return Future.value(
          InheritedBitmap(this, name, currentContext: currentContext));
    }
    return Future.value(TempGroupLayoutNode(this, currentContext, name,
        topLeftCorner: Point(boundaryRectangle.x, boundaryRectangle.y),
        bottomRightCorner: Point(boundaryRectangle.x + boundaryRectangle.width,
            boundaryRectangle.y + boundaryRectangle.height)));
  }

  bool areAllVectors() {
    if (children == null) {
      return false;
    }
    for (var child in children) {
      if (child is! FigmaVector) {
        return false;
      }
      if (child is FigmaText) {
        return false;
      }
    }
    return true;
  }

  Frame fitFrame() {
    var heights = [];
    var widths = [];
    for (var child in children) {
      heights.add(child.boundaryRectangle.height);
      widths.add(child.boundaryRectangle.width);
    }

    if (heights.every((element) => element == heights[0]) &&
        widths.every((element) => element == widths[0])) {
      return Frame(
        height: heights[0],
        width: widths[0],
        x: boundaryRectangle.x,
        y: boundaryRectangle.y,
      );
    } else {
      return boundaryRectangle;
    }
  }

  String childrenHavePrototypeNode() {
    for (DesignNode child in children) {
      if (child.prototypeNodeUUID != null) {
        return child.prototypeNodeUUID;
      }
    }
    return null;
  }

  @override
  String pbdfType = 'group';
}
