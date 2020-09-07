import 'package:parabeac_core/generation/prototyping/pb_prototype_node.dart';

class PBPrototypeStorage {
  static final PBPrototypeStorage _singleInstance =
      PBPrototypeStorage._internal();

  factory PBPrototypeStorage() => _singleInstance;
  PBPrototypeStorage._internal();

  ///All the prototype Instances
  final Map<String, PrototypeNode> _pbPrototypeInstanceNodes = {};
}
