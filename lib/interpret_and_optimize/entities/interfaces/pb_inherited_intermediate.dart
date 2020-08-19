

import 'package:parabeac_core/input/entities/layers/abstract_layer.dart';

/// Interface that defines that the node was derived from the design files.
abstract class PBInheritedIntermediate {
  final SketchNode originalRef;

  PBInheritedIntermediate(this.originalRef);
}