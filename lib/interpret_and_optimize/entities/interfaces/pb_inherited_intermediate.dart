import 'package:parabeac_core/interpret_and_optimize/entities/interfaces/pb_prototype_enabled.dart';

/// Interface that defines that the node was derived from the design files.
abstract class PBInheritedIntermediate implements PrototypeEnable {
  final Map<String, dynamic> originalRef;
  PBInheritedIntermediate(this.originalRef);

  static Map<String, dynamic> originalRefFromJson(Map<String, dynamic> json) =>
      json;
}
