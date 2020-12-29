import 'package:parabeac_core/generation/generators/pb_generator.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_context.dart';
import 'package:parabeac_core/interpret_and_optimize/state_management/intermediate_auxillary_data.dart';
import 'package:parabeac_core/interpret_and_optimize/value_objects/point.dart';
import 'package:quick_log/quick_log.dart';

/// PB’s  representation of the intermediate representation for a sketch node.
/// Usually, we work with its subclasses. We normalize several aspects of data that a sketch node presents in order to work better at the intermediate level.
/// Sometimes, PBNode’s do not have a direct representation of a sketch node. For example, most layout nodes are primarily made through and understanding of a need for a layout.
abstract class PBIntermediateNode {
  static final logger = Logger('PBIntermediateNode');

  /// A subsemantic is contextual info to be analyzed in or in-between the visual generation & layout generation services.
  String subsemantic;

  PBGenerator generator;

  final String UUID;
  var child;

  Point topLeftCorner;
  Point bottomRightCorner;

  PBContext currentContext;

  /// Size of the element.
  Map size;

  /// Auxillary Data of the node. Contains properties such as BorderInfo, Alignment, Color & a directed graph of states relating to this element.
  IntermediateAuxiliaryData auxiliaryData = IntermediateAuxiliaryData();

  /// Name of the element if available.
  String name;

  PBIntermediateNode(
      this.topLeftCorner, this.bottomRightCorner, this.UUID, this.name,
      {this.currentContext, this.subsemantic}) {
    if (topLeftCorner != null && bottomRightCorner != null) {
      /// TODO: For some reason `bottomRightCorner.x` is one pixel bigger than `topLeftCorner.x`
      // assert(topLeftCorner.x <= bottomRightCorner.x &&
      //     topLeftCorner.y <= bottomRightCorner.y);
    }
  }

  /// Adds child to node.
  void addChild(PBIntermediateNode node);
}
