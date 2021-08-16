import 'dart:collection';
import 'dart:math';

import 'package:directed_graph/directed_graph.dart';
import 'package:parabeac_core/generation/generators/pb_generator.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_constraints.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/align_strategy.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/child_strategy.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/abstract_intermediate_node_factory.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_context.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_intermediate_dfs_iterator.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_intermediate_node_tree.dart';
import 'package:parabeac_core/interpret_and_optimize/state_management/intermediate_auxillary_data.dart';
// import 'dart:math';
import 'package:quick_log/quick_log.dart';

/// PB’s  representation of the intermediate representation for a sketch node.
/// Usually, we work with its subclasses. We normalize several aspects of data that a sketch node presents in order to work better at the intermediate level.
/// Sometimes, PBNode’s do not have a direct representation of a sketch node. For example, most layout nodes are primarily made through and understanding of a need for a layout.
import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid.dart';

part 'pb_intermediate_node.g.dart';

@JsonSerializable(
    explicitToJson: true, createFactory: false, ignoreUnannotated: true)
abstract class PBIntermediateNode //extends Iterable<PBIntermediateNode>
{
  @JsonKey(ignore: true)
  Logger logger;

  @JsonKey(ignore: true)
  String attributeName;

  /// A subsemantic is contextual info to be analyzed in or in-between the visual generation & layout generation services.
  String subsemantic;

  @JsonKey(ignore: true)
  PBGenerator generator;

  @JsonKey()
  String get UUID => _UUID;
  String _UUID;

  @JsonKey(ignore: true)
  PBIntermediateConstraints constraints;

  @JsonKey(ignore: true)
  PBIntermediateNode parent;

  @JsonKey(ignore: true)
  ChildrenStrategy childrenStrategy = OneChildStrategy('child');

  @JsonKey(ignore: true)
  AlignStrategy alignStrategy = NoAlignment();

  @JsonKey(
      ignore: false,
      name: 'boundaryRectangle',
      fromJson: DeserializedRectangle.fromJson,
      toJson: DeserializedRectangle.toJson)
  Rectangle frame;

  // @JsonKey(ignore: true)
  // PBGenerationViewData get managerData => currentContext.tree.data;

  /// Auxillary Data of the node. Contains properties such as BorderInfo, Alignment, Color & a directed graph of states relating to this element.
  @JsonKey(name: 'style')
  IntermediateAuxiliaryData auxiliaryData = IntermediateAuxiliaryData();

  /// Name of the element if available.
  @JsonKey(ignore: false)
  String name;

  PBIntermediateNode(this._UUID, this.frame, this.name,
      {this.subsemantic, this.constraints}) {
    logger = Logger(runtimeType.toString());
    if (_UUID == null) {
      logger.warning(
          'Generating UUID for $runtimeType-$name as its UUID is null');
      _UUID = Uuid().v4();
    }
    // _attributes = [];
  }

  /// Returns the [PBAttribute] named `attributeName`. Returns
  /// null if the [PBAttribute] does not exist.
  PBIntermediateNode getAttributeNamed(
      PBIntermediateTree tree, String attributeName) {
    return tree
        .edges(AITVertex(this))
        .firstWhere((element) => element.data.attributeName == attributeName,
            orElse: () => null)
        ?.data;
  }

  List<PBIntermediateNode> getAllAtrributeNamed(
      PBIntermediateTree tree, String attributeName) {
    return tree
        .edges(AITVertex(this))
        .where((element) => element.data.attributeName == attributeName)
        .map((vertex) => vertex.data)
        .toList();
  }

  void replaceAttribute(
      PBIntermediateTree tree, String attributeName, PBIntermediateNode node,
      {bool allApperences = true}) {
    if (hasAttribute(tree, attributeName)) {
      tree.removeEdges(
          AITVertex(this),
          allApperences
              ? tree
                  .edges(AITVertex(this))
                  .map((child) => child.data.attributeName = attributeName)
              : tree.edges(AITVertex(this)).first);
      tree.addEdges(AITVertex(this), [AITVertex(node)]);
    }
  }

  /// Returns true if there is an attribute in the node's `attributes`
  /// that matches `attributeName`. Returns false otherwise.
  bool hasAttribute(PBIntermediateTree tree, String attributeName) {
    return tree
        .edges(AITVertex(this))
        .any((vertex) => vertex.data.attributeName == attributeName);
  }

  /// Adds child to node.
  // void addChild(PBIntermediateNode node) {
  //   childrenStrategy.addChild(this, node);

  //   /// Checking the constrains of the [node] being added to the tree, smoe of the
  //   /// constrains could be inherited to that section of the sub-tree.
  // }

  String getAttributeNameOf(PBIntermediateNode node) =>
      childrenStrategy.attributeName;

  @override
  int get hashCode => UUID.hashCode;

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

    ///FIXME for (var currChild in children ?? []) {
    ///FIXME currChild?.align(context.clone());
    ///FIXME }
  }

  @override
  String toString() {
    return name ?? runtimeType;
  }

  factory PBIntermediateNode.fromJson(Map<String, dynamic> json,
          PBIntermediateNode parent, PBIntermediateTree tree) =>
      AbstractIntermediateNodeFactory.getIntermediateNode(json, parent, tree);

  Map<String, dynamic> toJson() => _$PBIntermediateNodeToJson(this);

  void mapRawChildren(Map<String, dynamic> json, PBIntermediateTree tree) {
    var rawChildren = json['children'] as List;
    rawChildren?.forEach((rawChild) {
      if (rawChild != null) {
        PBIntermediateNode.fromJson(rawChild, this, tree);
        // tree.addEdges(Vertex(rawChild), [Vertex(parent)]);
        // addChild();PBIntermediateNode.fromJson(rawChild)
      }
    });
  }
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
  bool _areXCoordinatesOverlapping(
          Point topLeftCorner0,
          Point bottomRightCorner0,
          Point topLeftCorner1,
          Point bottomRightCorner1) =>
      topLeftCorner1.x >= topLeftCorner0.x &&
          topLeftCorner1.x <= bottomRightCorner0.x ||
      bottomRightCorner1.x <= bottomRightCorner0.x &&
          bottomRightCorner1.x >= topLeftCorner0.x;

  bool _areYCoordinatesOverlapping(
          Point topLeftCorner0,
          Point bottomRightCorner0,
          Point topLeftCorner1,
          Point bottomRightCorner1) =>
      topLeftCorner1.y >= topLeftCorner0.y &&
          topLeftCorner1.y <= bottomRightCorner0.y ||
      bottomRightCorner1.y <= bottomRightCorner0.y &&
          bottomRightCorner1.y >= topLeftCorner0.y;

  bool isHorizontalTo(Rectangle frame) {
    return (!(_areXCoordinatesOverlapping(
            topLeft, bottomRight, frame.topLeft, frame.bottomRight))) &&
        _areYCoordinatesOverlapping(
            topLeft, bottomRight, frame.topLeft, frame.bottomRight);
  }

  bool isVerticalTo(Rectangle frame) {
    return (!(_areYCoordinatesOverlapping(
            topLeft, bottomRight, frame.topLeft, frame.bottomRight))) &&
        _areXCoordinatesOverlapping(
            topLeft, bottomRight, frame.topLeft, frame.bottomRight);
  }

  bool isOverlappingTo(Rectangle frame) {
    return (_areXCoordinatesOverlapping(
            topLeft, bottomRight, frame.topLeft, frame.bottomRight)) &&
        _areYCoordinatesOverlapping(
            topLeft, bottomRight, frame.topLeft, frame.bottomRight);
  }

  static Rectangle fromJson(Map<String, dynamic> json) {
    return Rectangle(json['x'], json['y'], json['width'], json['height']);
  }

  static Map toJson(Rectangle rectangle) => {
        'height': rectangle.height,
        'width': rectangle.width,
        'x': rectangle.left,
        'y': rectangle.top
      };
}
