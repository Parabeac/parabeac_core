import 'package:parabeac_core/input/figma/entities/layers/canvas.dart';
import 'package:parabeac_core/input/figma/entities/layers/frame.dart';
import 'package:parabeac_core/input/figma/entities/layers/group.dart';

import 'layers/figma_node.dart';
import 'layers/vector.dart';

class AbstractFigmaNodeFactory {
  static final String FIGMA_CLASS_KEY = '_class';

  static final List<FigmaNodeFactory> _figmaNodes = [
    Canvas(),
    FigmaFrame(),
    Group(),
    FigmaVector(),
  ];

  AbstractFigmaNodeFactory();

  static FigmaNode getFigmaNode(Map<String, dynamic> json) {
    var className = json[FIGMA_CLASS_KEY];
    if (className != null) {
      for (var figmaNode in _figmaNodes) {
        if (figmaNode.type == className) {
          return figmaNode.createFigmaNode(json);
        }
      }
    }
    return null;
  }
}

abstract class FigmaNodeFactory {
  String type;
  FigmaNode createFigmaNode(Map<String, dynamic> json);
}
