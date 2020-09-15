import 'package:parabeac_core/input/sketch/entities/layers/abstract_group_layer.dart';
import 'package:parabeac_core/input/sketch/entities/layers/abstract_layer.dart';
import 'package:parabeac_core/input/sketch/entities/layers/artboard.dart';
import 'package:parabeac_core/input/sketch/entities/layers/group.dart';

import '../entities/layers/symbol_master.dart';

///Class for cleansing the positional data of the [SketchNode]
///TODO(Eddie): Abstract it, not only for Sketch node but potentially more design files.
class PositionalCleansingService {
  ///Eliminating the offset of the nodes. NOTE: the only nodes that have an offset are [Artboard] and [Group]
  SketchNode eliminateOffset(SketchNode rootNode) {
    if (rootNode is Group || rootNode is Artboard || rootNode is SymbolMaster) {
      _eliminateOffsetChildren(
          (rootNode as AbstractGroupLayer).layers, rootNode);
    }
    if (rootNode is AbstractGroupLayer) {
      rootNode.layers.map((layerNode) => eliminateOffset(layerNode)).toList();
    }
    return rootNode;
  }

  void _eliminateOffsetChildren(List children, SketchNode parent) =>
      children.forEach((child) {
        child.boundaryRectangle.x =
            (parent.boundaryRectangle.x + child.boundaryRectangle.x);
        child.boundaryRectangle.y =
            (parent.boundaryRectangle.y + child.boundaryRectangle.y);
      });
}
