import 'dart:collection';

import 'package:parabeac_core/interpret_and_optimize/helpers/pb_intermediate_node_tree.dart';

class ElementStorage {
  static final ElementStorage _elementStorageInstance = ElementStorage._internal();

  /// This [Map] contains the [PBIntermediateNode.UUID] to [PBIntermediateTree.UUID].
  ///
  /// This is primarly used to find a particular [PBIntermediateNode]s [PBIntermediateTree]
  final elementToTree = <String, String>{};

  /// Key value pair for [PBIntermediateTree.UUID] to [PBIntermediateTree]
  final treeUUIDs = <String, PBIntermediateTree>{};

  factory ElementStorage() => _elementStorageInstance;
  ElementStorage._internal();
}
