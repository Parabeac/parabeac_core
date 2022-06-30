import 'dart:collection';
import 'dart:math';

import 'package:directed_graph/directed_graph.dart';
import 'package:parabeac_core/generation/generators/pb_generator.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/layouts/group/frame_group.dart';
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
import 'package:uuid/uuid.dart';

part 'pb_intermediate_node.g.dart';

@JsonSerializable(
    explicitToJson: true, createFactory: false, ignoreUnannotated: true)
abstract class PBIntermediateNode
    extends Vertex<PBIntermediateNode> //extends Iterable<PBIntermediateNode>
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

  @JsonKey(ignore: false)
  PBIntermediateConstraints constraints;

  @JsonKey(ignore: true)
  PBIntermediateNode parent;

  @JsonKey(ignore: true)
  ChildrenStrategy childrenStrategy = OneChildStrategy('child');

  @JsonKey(ignore: true)
  AlignStrategy alignStrategy = NoAlignment();

  @JsonKey(ignore: false)
  ParentLayoutSizing layoutMainAxisSizing;
  @JsonKey(ignore: false)
  ParentLayoutSizing layoutCrossAxisSizing;

  @JsonKey(
      ignore: false,
      name: 'boundaryRectangle',
      fromJson: Rectangle3D.fromJson,
      toJson: Rectangle3D.toJson)
  Rectangle3D frame;

  // @JsonKey(ignore: true)
  // PBGenerationViewData get managerData => currentContext.tree;

  /// Auxillary Data of the node. Contains properties such as BorderInfo, Alignment, Color & a directed graph of states relating to this element.
  @JsonKey(name: 'style')
  IntermediateAuxiliaryData auxiliaryData;

  /// Name of the element if available.
  @JsonKey(ignore: false)
  String name;

  PBIntermediateNode(
    this._UUID,
    this.frame,
    this.name, {
    this.subsemantic,
    this.constraints,
    this.auxiliaryData,
  }) :

        /// We are not using the [Vertex] attribute as it represents the [PBIntermediateNode]
        super(null) {
    logger = Logger(runtimeType.toString());
    if (_UUID == null) {
      logger
          .debug('Generating UUID for $runtimeType-$name as its UUID is null');
      _UUID = Uuid().v4();
    }

    if (constraints == null) {
      logger.debug(
          'Constraints are null for $runtimeType-$name, assigning it default constraints');
      constraints = PBIntermediateConstraints.defaultConstraints();
    }
    auxiliaryData ??= IntermediateAuxiliaryData();
  }

  /// Returns the [PBAttribute] named `attributeName`. Returns
  /// null if the [PBAttribute] does not exist.
  PBIntermediateNode getAttributeNamed(
      PBIntermediateTree tree, String attributeName) {
    return tree.edges(this).cast<PBIntermediateNode>().firstWhere(
        (child) => child.attributeName == attributeName,
        orElse: () => null);
  }

  List<PBIntermediateNode> getAllAtrributeNamed(
      PBIntermediateTree tree, String attributeName) {
    return tree
        .edges(this)
        .cast<PBIntermediateNode>()
        .where((child) => child.attributeName == attributeName)
        .toList();
  }

  void replaceAttribute(
      PBIntermediateTree tree, String attributeName, PBIntermediateNode node,
      {bool allApperences = true}) {
    if (hasAttribute(tree, attributeName)) {
      tree.removeEdges(
          this,
          allApperences
              ? tree
                  .edges(this)
                  .cast<PBIntermediateNode>()
                  .map((child) => child.attributeName = attributeName)
              : tree.edges(this).first);
      tree.addEdges(this, [node]);
    }
  }

  /// Returns true if there is an attribute in the node's `attributes`
  /// that matches `attributeName`. Returns false otherwise.
  bool hasAttribute(PBIntermediateTree tree, String attributeName) {
    return tree
        .edges(this)
        .cast<PBIntermediateNode>()
        .any((child) => child.attributeName == attributeName);
  }

  String getAttributeNameOf(PBIntermediateNode node) =>
      childrenStrategy.attributeName;

  @override
  int get hashCode => UUID.hashCode;

  @override
  int get id => UUID.hashCode;

  @override
  bool operator ==(Object other) =>
      other is PBIntermediateNode && other.id == id;

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
    // alignStrategy.setConstraints(context, this);
    alignStrategy.align(context.clone(), this);

    for (var currChild in context.tree.childrenOf(this) ?? []) {
      currChild?.align(context.clone());
    }
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
    var parentConstraints = json['constraints'];
    rawChildren?.forEach((rawChild) {
      if (rawChild != null) {
        /// Child inherit Parent's constraints if they are fixed
        /// on that axis
        /// This rule was added for Auto Layouts since we will not be using
        /// LayoutBuilder for the moment
        if (this is FrameGroup) {
          if (parentConstraints['fixedHeight']) {
            rawChild['constraints']['fixedHeight'] =
                parentConstraints['fixedHeight'];
            rawChild['constraints']['pinTop'] = parentConstraints['pinTop'];
            rawChild['constraints']['pinBottom'] =
                parentConstraints['pinBottom'];
          }

          if (parentConstraints['fixedWidth']) {
            rawChild['constraints']['fixedWidth'] =
                parentConstraints['fixedWidth'];
            rawChild['constraints']['pinLeft'] = parentConstraints['pinLeft'];
            rawChild['constraints']['pinRight'] = parentConstraints['pinRight'];
          }
        }
        PBIntermediateNode.fromJson(rawChild, this, tree);
      }
    });
  }
}

extension PBPointLegacyMethod on Point {
  Point clone() => Point(x, y);

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

  static Map toJson(Point point) => {'x': point.x, 'y': point.y};
}

class Rectangle3D<T extends num> extends Rectangle<T> {
  ///For now we are unable to make any comparison in the z-axis, this
  ///is primarly for sorting elements in [PBStackIntermediateLayout] to
  ///place to correct [PBIntermediateNode]s on top.
  num z;
  Rectangle3D(num left, num top, num width, num height, this.z)
      : super(left, top, width, height);

  @override
  Rectangle<T> boundingBox(Rectangle<T> frame) {
    var z = 0;
    if (frame is Rectangle3D) {
      z = max(z, (frame as Rectangle3D).z.toInt());
    }
    return Rectangle3D.from2DRectangle(super.boundingBox(frame), z: z);
  }

  factory Rectangle3D.from2DRectangle(Rectangle rectangle, {int z = 0}) =>
      Rectangle3D(
          rectangle.left, rectangle.top, rectangle.width, rectangle.height, z);

  static Rectangle3D fromJson(Map<String, dynamic> json) {
    return Rectangle3D(
        json['x'], json['y'], json['width'], json['height'], json['z'] ?? 0);
  }

  factory Rectangle3D.fromPoints(Point<T> a, Point<T> b, {T z}) {
    var left = min(a.x, b.x);
    var width = (max(a.x, b.x) - left) as T;
    var top = min(a.y, b.y);
    var height = (max(a.y, b.y) - top) as T;
    return Rectangle3D<T>(left, top, width, height, z);
  }

  static Map toJson(Rectangle3D Rectangle3D) => {
        'height': Rectangle3D.height,
        'width': Rectangle3D.width,
        'x': Rectangle3D.left,
        'y': Rectangle3D.top,
        'z': Rectangle3D.z
      };

  Rectangle3D copyWith({
    num left,
    num top,
    num width,
    num height,
    num z,
  }) {
    return Rectangle3D(
      left ?? this.left,
      top ?? this.top,
      width ?? this.width,
      height ?? this.height,
      z ?? this.z,
    );
  }
}

extension DeserializedRectangle3D on Rectangle3D {
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

  bool isHorizontalTo(Rectangle3D frame) {
    return (!(_areXCoordinatesOverlapping(
            topLeft, bottomRight, frame.topLeft, frame.bottomRight))) &&
        _areYCoordinatesOverlapping(
            topLeft, bottomRight, frame.topLeft, frame.bottomRight);
  }

  bool isVerticalTo(Rectangle3D frame) {
    return (!(_areYCoordinatesOverlapping(
            topLeft, bottomRight, frame.topLeft, frame.bottomRight))) &&
        _areXCoordinatesOverlapping(
            topLeft, bottomRight, frame.topLeft, frame.bottomRight);
  }

  bool isOverlappingTo(Rectangle3D frame) {
    return (_areXCoordinatesOverlapping(
            topLeft, bottomRight, frame.topLeft, frame.bottomRight)) &&
        _areYCoordinatesOverlapping(
            topLeft, bottomRight, frame.topLeft, frame.bottomRight);
  }
}

enum ParentLayoutSizing { INHERIT, STRETCH }
