import 'dart:collection';
import 'dart:math';

import 'package:parabeac_core/generation/generators/pb_generator.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_constraints.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/align_strategy.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/child_strategy.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/abstract_intermediate_node_factory.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_context.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_intermediate_node_tree.dart';
import 'package:parabeac_core/interpret_and_optimize/state_management/intermediate_auxillary_data.dart';
// import 'dart:math';
import 'package:quick_log/quick_log.dart';

/// PB’s  representation of the intermediate representation for a sketch node.
/// Usually, we work with its subclasses. We normalize several aspects of data that a sketch node presents in order to work better at the intermediate level.
/// Sometimes, PBNode’s do not have a direct representation of a sketch node. For example, most layout nodes are primarily made through and understanding of a need for a layout.
import 'package:json_annotation/json_annotation.dart';

part 'pb_intermediate_node.g.dart';

@JsonSerializable(
    explicitToJson: true, createFactory: false, ignoreUnannotated: true)
abstract class PBIntermediateNode //extends Iterable<PBIntermediateNode>
    implements TraversableNode<PBIntermediateNode> {
  @JsonKey(ignore: true)
  Logger logger;

  @override
  @JsonKey(ignore: true)
  String attributeName;

  /// A subsemantic is contextual info to be analyzed in or in-between the visual generation & layout generation services.
  String subsemantic;

  @JsonKey(ignore: true)
  PBGenerator generator;

  @JsonKey()
  final String UUID;

  @JsonKey(ignore: true)
  PBIntermediateConstraints constraints;

  /// Map representing the attributes of [this].
  /// The key represents the name of the attribute, while the value
  /// is a List<PBIntermediateNode> representing the nodes under
  /// that attribute.
  // @JsonKey(
  //   name: 'children',
  //   fromJson: _childrenFromJson,
  //   toJson: _childrenToJson,
  //   nullable: true,
  // )
  // List<PBAttribute> _attributes;

  // // TODO(eddie) this is a work around that is currently being tested, delete afterwards
  // @JsonKey(name: 'child', fromJson: _childToJson, nullable: true)
  // set _child(PBAttribute attribute) {
  //   _attributes ??= [];
  //   _attributes.add(attribute);
  // }

  // @JsonKey(ignore: true)
  // List<PBAttribute> get attributes => _attributes;
  @override
  @JsonKey(ignore: true)
  PBIntermediateNode parent;

  @override
  @JsonKey(ignore: true)
  List<PBIntermediateNode> children = [];

  @JsonKey(ignore: true)
  PBIntermediateNode get child => children.isEmpty ? null : children.first;

  // @override
  // @JsonKey(ignore: true)
  // Iterator<PBIntermediateNode> get iterator => children.iterator;

  @JsonKey(ignore: true)
  ChildrenStrategy childrenStrategy = OneChildStrategy('child');

  @JsonKey(ignore: true)
  AlignStrategy alignStrategy = NoAlignment();

  /// Gets the [PBIntermediateNode] at attribute `child`
  // PBIntermediateNode get child => getAttributeNamed('child')?.attributeNode;

  /// Sets the `child` attribute's `attributeNode` to `element`.
  /// If a `child` attribute does not yet exist, it creates it.
  // set child(PBIntermediateNode element) {
  //   if (element == null) {
  //     return;
  //   }
  //   if (!hasAttribute('child')) {
  //     addAttribute(PBAttribute('child', attributeNodes: [element]));
  //   } else {
  //     getAttributeNamed('child').attributeNode = element;
  //   }

  // }

  @JsonKey(
      ignore: false,
      name: 'boundaryRectangle',
      fromJson: DeserializedRectangle.fromJson,
      toJson: DeserializedRectangle.toJson)
  Rectangle frame;

  // @JsonKey(ignore: true)
  // PBContext currentContext;

  // @JsonKey(ignore: true)
  // PBGenerationViewData get managerData => currentContext.tree.data;

  /// Auxillary Data of the node. Contains properties such as BorderInfo, Alignment, Color & a directed graph of states relating to this element.
  @JsonKey(name: 'style')
  IntermediateAuxiliaryData auxiliaryData = IntermediateAuxiliaryData();

  /// Name of the element if available.
  @JsonKey(ignore: false)
  String name;

  PBIntermediateNode(this.UUID, this.frame, this.name,
      {this.subsemantic, this.constraints}) {
    logger = Logger(runtimeType.toString());
    // _attributes = [];
  }

  /// Returns the [PBAttribute] named `attributeName`. Returns
  /// null if the [PBAttribute] does not exist.
  PBIntermediateNode getAttributeNamed(String attributeName) {
    return children.firstWhere(
        (element) => element.attributeName == attributeName,
        orElse: () => null);
  }

  List<PBIntermediateNode> getAllAtrributeNamed(String attributeName) {
    return children
        .where((element) => element.attributeName == attributeName)
        .toList();
  }

  void replaceAttribute(String attributeName, PBIntermediateNode node,
      {bool allApperences = true}) {
    if (hasAttribute(attributeName)) {
      allApperences
          ? children
              .removeWhere((element) => element.attributeName == attributeName)
          : children.remove(children
              .firstWhere((element) => element.attributeName == attributeName));
      children.add(node);
    }
  }

  /// Returns true if there is an attribute in the node's `attributes`
  /// that matches `attributeName`. Returns false otherwise.
  bool hasAttribute(String attributeName) {
    return children.any((element) => element.attributeName == attributeName);
  }

  /// Adds the [PBAttribute] to this node's `attributes` list.
  /// When `overwrite` is set to true, if the provided `attribute` has the same
  /// name as another attribute in `attributes`, it will replace the old one.
  /// Returns true if the addition was successful, false otherwise.
  // bool addAttribute(PBAttribute attribute, {bool overwrite = false}) {
  //   // Iterate through the list of attributes
  //   for (var i = 0; i < attributes.length; i++) {
  //     var childAttr = attributes[i];

  //     // If there is a duplicate, replace if `overwrite` is true
  //     if (childAttr.attributeName == attribute.attributeName) {
  //       if (overwrite) {
  //         attributes[i] = attribute;
  //         return true;
  //       }
  //       return false;
  //     }
  //   }

  //   // Add attribute, no duplicate found
  //   attributes.add(attribute);
  //   return true;
  // }

  /// Adds child to node.
  void addChild(PBIntermediateNode node) {
    childrenStrategy.addChild(this, node);

    /// Checking the constrains of the [node] being added to the tree, smoe of the
    /// constrains could be inherited to that section of the sub-tree.
  }

  void handleChildren(PBContext context) {}

  /// In a recursive manner align the current [this] and the [children] of [this]
  ///
  /// Its creating a [PBContext.clone] because some values of the [context] are modified
  /// when passed to some of the [children].
  /// For example, the [context.contextConstraints] might
  /// could contain information from a parent to that particular section of the tree. However,
  /// because its pass by reference that edits to the context are going to affect the entire [context.tree] and
  /// not just the sub tree, therefore, we need to [PBContext.clone] to avoid those side effets.
  ///
  /// INFO: there might be a more straight fowards backtracking way of preventing these side effects.
  void align(PBContext context) {
    alignStrategy.align(context, this);
    for (var att in children ?? []) {
      var child = att.attributeNode;
      child?.align(context.clone());
    }
  }

  factory PBIntermediateNode.fromJson(Map<String, dynamic> json) =>
      AbstractIntermediateNodeFactory.getIntermediateNode(json);

  Map<String, dynamic> toJson() => _$PBIntermediateNodeToJson(this);

  void mapRawChildren(Map<String, dynamic> json) {
    var rawChildren = json['children'] as List;
    rawChildren?.forEach((child) {
      if (child != null) {
        addChild(PBIntermediateNode.fromJson(child));
      }
    });
  }

  // static List<PBAttribute> _childrenFromJson(Map<String, dynamic> json) {
  //   var key = 'children';
  //   var children = json[key] as List;
  //   return <PBAttribute>[
  //     PBAttribute(key,
  //         attributeNodes: children
  //             .map((child) => PBIntermediateNode.fromJson(child))
  //             .toList())
  //   ];
  // }

  // static Map<String, List> _childrenToJson(List<PBAttribute> attributes) {
  //   var mapEntries = attributes
  //       .map((PBAttribute attribute) => MapEntry(
  //           attribute.attributeName,
  //           attribute.attributeNode == null
  //               ? attribute.attributeNodes.map((e) => e.toJson()).toList()
  //               : [attribute.attributeNode.toJson()]))
  //       .toList();
  //   return Map.fromEntries(mapEntries);
  // }

  // static PBAttribute _childToJson(Map<String, dynamic> json) {
  //   var key = 'child';
  //   return PBAttribute(key,
  //       attributeNodes: [PBIntermediateNode.fromJson(json[key])]);
  // }
}

extension PBPointLegacyMethod on Point {
  Point clone() => Point(x, y);

  // TODO: This is a temporal fix ----- Not sure why there some sort of safe area for the y-axis??
  // (y.abs() - anotherPoint.y.abs()).abs() < 3
  int compareTo(Point anotherPoint) =>
      y == anotherPoint.y || (y.abs() - anotherPoint.y.abs()).abs() < 3
          ? x.compareTo(anotherPoint.x)
          : y.compareTo(anotherPoint.y);

  bool operator <(Object point) {
    if (point is Point) {
      return y == point.y ? x <= point.x : y <= point.y;
    }
    return false;
  }

  bool operator >(Object point) {
    if (point is Point) {
      return y == point.y ? x >= point.x : y >= point.y;
    }
    return false;
  }

  static Point topLeftFromJson(Map<String, dynamic> json) {
    if (json == null) {
      return null;
    }
    var x, y;
    if (json.containsKey('boundaryRectangle')) {
      x = json['boundaryRectangle']['x'];
      y = json['boundaryRectangle']['y'];
    } else {
      x = json['x'];
      y = json['y'];
    }
    return Point(x, y);
  }

  static Point bottomRightFromJson(Map<String, dynamic> json) {
    if (json == null) {
      return null;
    }
    var x, y;
    if (json.containsKey('boundaryRectangle')) {
      x = json['boundaryRectangle']['x'] + json['boundaryRectangle']['width'];
      y = json['boundaryRectangle']['y'] + json['boundaryRectangle']['height'];
    } else {
      x = json['x'] + json['width'];
      y = json['y'] + json['height'];
    }
    return Point(x, y);
  }

  static Map toJson(Point point) => {'x': point.x, 'y': point.y};
}

extension DeserializedRectangle on Rectangle {
  Point get topLeftCorner => topLeft;
  Point get bottomRightCorner => bottomRight;

  static Rectangle fromJson(Map<String, dynamic> json) {
    return Rectangle<num>(json['x'], json['y'], json['width'], json['height']);
  }

  static Map toJson(Rectangle rectangle) => {
        'height': rectangle.height,
        'width': rectangle.width,
        'x': rectangle.left,
        'y': rectangle.top
      };
}
