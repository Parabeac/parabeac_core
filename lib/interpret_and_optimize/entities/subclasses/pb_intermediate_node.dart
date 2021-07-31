import 'dart:math';

import 'package:parabeac_core/generation/generators/pb_generator.dart';
import 'package:parabeac_core/generation/generators/util/pb_generation_view_data.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_attribute.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/abstract_intermediate_node_factory.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_context.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_intermediate_node_tree.dart';
import 'package:parabeac_core/interpret_and_optimize/state_management/intermediate_auxillary_data.dart';
import 'package:parabeac_core/interpret_and_optimize/value_objects/point.dart';
import 'package:quick_log/quick_log.dart';

/// PB’s  representation of the intermediate representation for a sketch node.
/// Usually, we work with its subclasses. We normalize several aspects of data that a sketch node presents in order to work better at the intermediate level.
/// Sometimes, PBNode’s do not have a direct representation of a sketch node. For example, most layout nodes are primarily made through and understanding of a need for a layout.
import 'package:json_annotation/json_annotation.dart';

part 'pb_intermediate_node.g.dart';

@JsonSerializable(
  explicitToJson: true,
  createFactory: false,
)
abstract class PBIntermediateNode extends TraversableNode<PBIntermediateNode> {
  static final logger = Logger('PBIntermediateNode');

  /// A subsemantic is contextual info to be analyzed in or in-between the visual generation & layout generation services.
  String subsemantic;

  @JsonKey(ignore: true)
  PBGenerator generator;

  @JsonKey()
  final String UUID;

  /// Map representing the attributes of [this].
  /// The key represents the name of the attribute, while the value
  /// is a List<PBIntermediateNode> representing the nodes under
  /// that attribute.
  List<PBAttribute> _attributes;

  @JsonKey(ignore: true)
  List<PBAttribute> get attributes => _attributes;

  @override
  List<PBIntermediateNode> get children => [child];

  /// Gets the [PBIntermediateNode] at attribute `child`
  PBIntermediateNode get child => getAttributeNamed('child')?.attributeNode;

  /// Sets the `child` attribute's `attributeNode` to `element`.
  /// If a `child` attribute does not yet exist, it creates it.
  set child(PBIntermediateNode element) {
    if (element == null) {
      return;
    }
    if (!hasAttribute('child')) {
      addAttribute(PBAttribute('child', attributeNodes: [element]));
    } else {
      getAttributeNamed('child').attributeNode = element;
    }
  }

  @JsonKey(fromJson: Point.topLeftFromJson)
  Point topLeftCorner;

  @JsonKey(fromJson: Point.bottomRightFromJson)
  Point bottomRightCorner;

  @JsonKey(ignore: true)
  PBContext currentContext;

  @JsonKey(ignore: true)
  PBGenerationViewData get managerData => currentContext.tree.data;

  Map size;

  /// Auxillary Data of the node. Contains properties such as BorderInfo, Alignment, Color & a directed graph of states relating to this element.
  @JsonKey(name: 'style')
  IntermediateAuxiliaryData auxiliaryData = IntermediateAuxiliaryData();

  /// Name of the element if available.
  String name;

  PBIntermediateNode(
      this.topLeftCorner, this.bottomRightCorner, this.UUID, this.name,
      {this.currentContext, this.subsemantic}) {
    _attributes = [];
    _pointCorrection();
  }

  ///Correcting the pints when given the incorrect ones
  void _pointCorrection() {
    if (topLeftCorner != null && bottomRightCorner != null) {
      if (topLeftCorner.x > bottomRightCorner.x &&
          topLeftCorner.y > bottomRightCorner.y) {
        logger.warning(
            'Correcting the positional data. BTC is higher than TLC for node: ${this}');
        topLeftCorner = Point(min(topLeftCorner.x, bottomRightCorner.x),
            min(topLeftCorner.y, bottomRightCorner.y));
        bottomRightCorner = Point(max(topLeftCorner.x, bottomRightCorner.x),
            max(topLeftCorner.y, bottomRightCorner.y));
      }
    }
  }

  /// Returns the [PBAttribute] named `attributeName`. Returns
  /// null if the [PBAttribute] does not exist.
  PBAttribute getAttributeNamed(String attributeName) {
    for (var attribute in attributes) {
      if (attribute.attributeName == attributeName) {
        return attribute;
      }
    }
    return null;
  }

  /// Returns true if there is an attribute in the node's `attributes`
  /// that matches `attributeName`. Returns false otherwise.
  bool hasAttribute(String attributeName) {
    for (var attribute in attributes) {
      if (attribute.attributeName == attributeName) {
        return true;
      }
    }
    return false;
  }

  /// Adds the [PBAttribute] to this node's `attributes` list.
  /// When `overwrite` is set to true, if the provided `attribute` has the same
  /// name as another attribute in `attributes`, it will replace the old one.
  /// Returns true if the addition was successful, false otherwise.
  bool addAttribute(PBAttribute attribute, {bool overwrite = false}) {
    // Iterate through the list of attributes
    for (var i = 0; i < attributes.length; i++) {
      var childAttr = attributes[i];

      // If there is a duplicate, replace if `overwrite` is true
      if (childAttr.attributeName == attribute.attributeName) {
        if (overwrite) {
          attributes[i] = attribute;
          return true;
        }
        return false;
      }
    }

    // Add attribute, no duplicate found
    attributes.add(attribute);
    return true;
  }

  /// Adds child to node.
  void addChild(PBIntermediateNode node);

  factory PBIntermediateNode.fromJson(Map<String, dynamic> json) =>
      AbstractIntermediateNodeFactory.getIntermediateNode(json)..auxiliaryData;

  Map<String, dynamic> toJson() => _$PBIntermediateNodeToJson(this);

  static Map sizeFromJson(Map<String, dynamic> json) {
    return {
      'width': json['width'],
      'height': json['height'],
    };
  }

  void mapRawChildren(Map<String, dynamic> json) {
    var rawChildren = json['children'] as List;
    rawChildren?.forEach((child) {
      if (child != null) {
        addChild(PBIntermediateNode.fromJson(child));
      }
    });
  }
}
