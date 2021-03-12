import 'package:parabeac_core/design_logic/design_node.dart';
import 'package:parabeac_core/design_logic/pb_style.dart';
import 'package:parabeac_core/design_logic/text.dart';
import 'package:parabeac_core/input/figma/entities/abstract_figma_node_factory.dart';
import 'package:parabeac_core/input/figma/entities/layers/vector.dart';
import 'package:parabeac_core/input/figma/entities/style/figma_style.dart';
import 'package:parabeac_core/input/figma/helper/style_extractor.dart';
import 'package:parabeac_core/input/sketch/entities/objects/frame.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/inherited_container.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/inherited_text.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_context.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:parabeac_core/interpret_and_optimize/value_objects/point.dart';

import 'figma_node.dart';

part 'text.g.dart';

@JsonSerializable(nullable: true)
class FigmaText extends FigmaVector implements AbstractFigmaNodeFactory, Text {
  @override
  String type = 'TEXT';
  FigmaText(
      {String name,
      bool visible,
      String type,
      pluginData,
      sharedPluginData,
      FigmaStyle this.style,
      layoutAlign,
      constraints,
      Frame boundaryRectangle,
      size,
      fills,
      strokes,
      strokeWeight,
      strokeAlign,
      styles,
      this.content,
      this.characterStyleOverrides,
      this.styleOverrideTable,
      String prototypeNodeUUID,
      num transitionDuration,
      String transitionEasing})
      : super(
          name: name,
          visible: visible,
          type: type,
          pluginData: pluginData,
          sharedPluginData: sharedPluginData,
          style: style,
          layoutAlign: layoutAlign,
          constraints: constraints,
          boundaryRectangle: boundaryRectangle,
          size: size,
          strokes: strokes,
          strokeWeight: strokeWeight,
          strokeAlign: strokeAlign,
          styles: styles,
          prototypeNodeUUID: prototypeNodeUUID,
          transitionDuration: transitionDuration,
          transitionEasing: transitionEasing,
        ) {
    pbdfType = 'text';
  }

  @override
  @JsonKey(name: 'characters')
  String content;

  @override
  PBStyle style;

  List<double> characterStyleOverrides;

  Map styleOverrideTable;

  @override
  FigmaNode createFigmaNode(Map<String, dynamic> json) {
    var node = FigmaText.fromJson(json);
    node.style = StyleExtractor().getStyle(json);
    return node;
  }

  factory FigmaText.fromJson(Map<String, dynamic> json) =>
      _$FigmaTextFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$FigmaTextToJson(this);

  @override
  Future<PBIntermediateNode> interpretNode(PBContext currentContext) {
    return Future.value(InheritedContainer(
      this,
      Point(boundaryRectangle.x, boundaryRectangle.y),
      Point(boundaryRectangle.x + boundaryRectangle.width,
          boundaryRectangle.y + boundaryRectangle.height),
      name,
      currentContext: currentContext,
      isBackgroundVisible: style.backgroundColor != null,
    )..addChild(
        InheritedText(this, name, currentContext: currentContext),
      ));
  }

  @override
  Map<String, dynamic> toPBDF() => toJson();

  @override
  String pbdfType = 'text';

  @override
  DesignNode createDesignNode(Map<String, dynamic> json) {
    // TODO: implement createDesignNode
    throw UnimplementedError();
  }

  @override
  DesignNode fromPBDF(Map<String, dynamic> json) {
    // TODO: implement fromPBDF
    throw UnimplementedError();
  }

  @override
  var attributedString;

  @override
  var automaticallyDrawOnUnderlyingPath;

  @override
  var dontSynchroniseWithSymbol;

  @override
  var glyphBounds;

  @override
  var lineSpacingBehaviour;

  @override
  var textBehaviour;
}
