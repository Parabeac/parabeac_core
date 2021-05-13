import 'dart:collection';

import 'package:parabeac_core/eggs/injected_app_bar.dart';
import 'package:parabeac_core/eggs/injected_tab_bar.dart';
import 'package:parabeac_core/generation/prototyping/pb_dest_holder.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/inherited_scaffold.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/pb_shared_instance.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_layout_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_gen_cache.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_intermediate_node_tree.dart';

class ImportHelper {
  /// Traverse the [node] tree, check if any nodes need importing,
  /// and add the relative import from [path] to the [node]
  static Set<String> findImports(PBIntermediateNode node, String path) {
    Set imports = <String>{};
    if (node == null) {
      return imports;
    }

    String id;
    if (node is PBSharedInstanceIntermediateNode) {
      id = node.SYMBOL_ID;
    } else if (node is PBDestHolder) {
      id = node.pNode.destinationUUID;
    } else {
      id = node.UUID;
    }

    var nodePaths = PBGenCache().getPaths(id);
    // Make sure nodePath exists and is not the same as path (importing yourself)
    if (nodePaths != null &&
        nodePaths.isNotEmpty &&
        !nodePaths.any((element) => element == path)) {
      var paths = PBGenCache().getRelativePath(path, id);
      paths.forEach(imports.add);
    }

    // Recurse through child/children and add to imports
    if (node is PBLayoutIntermediateNode) {
      node.children
          .forEach((child) => imports.addAll(findImports(child, path)));
    } else if (node is InheritedScaffold) {
      imports.addAll(findImports(node.navbar, path));
      imports.addAll(findImports(node.tabbar, path));
      imports.addAll(findImports(node.child, path));
    } else if (node is InjectedAppbar) {
      imports.addAll(findImports(node.leadingItem, path));
      imports.addAll(findImports(node.middleItem, path));
      imports.addAll(findImports(node.trailingItem, path));
    } else if (node is InjectedTabBar) {
      for (var tab in node.tabs) {
        imports.addAll(findImports(tab, path));
      }
    } else {
      imports.addAll(findImports(node.child, path));
    }

    return imports;
  }
}

///Iterating through the screens in a manner where, the screens that are
///dependent are processed first.
class IntermediateTopoIterator<E extends PBIntermediateTree>
    implements Iterator<E> {
  List<E> trees;

  E _currentElement;

  @override
  E get current => _currentElement;

  IntermediateTopoIterator(this.trees) {
    trees = topologicalSort(trees);
    if (trees.isNotEmpty) {
      _currentElement = trees[0];
    }
  }

  HashMap<E, int> _inDegrees(List<PBIntermediateTree> trees) {
    var inDegree = HashMap<E, int>();
    trees.forEach((tree) {
      inDegree.putIfAbsent(tree, () => 0);
      tree.dependentsOn.forEach((dependent) {
        inDegree.update(dependent, (value) => value + 1, ifAbsent: () => 1);
      });
    });
    return inDegree;
  }

  ///Performing topological sort in the on the screens that were received.
  List<E> topologicalSort(List<E> items) {
    var ordered = <E>[];
    var noInDegrees = <E>{};
    var inDegrees = _inDegrees(items);

    inDegrees.forEach((key, value) {
      if (value == 0) {
        noInDegrees.add(key);
      }
    });

    while (noInDegrees.isNotEmpty) {
      var vertex = noInDegrees.first;
      noInDegrees.remove(vertex);
      ordered.add(vertex);

      vertex.dependentsOn.forEach((dependent) {
        inDegrees[dependent] = inDegrees[dependent] - 1;
        if (inDegrees[dependent] == 0) {
          noInDegrees.add(dependent);
        }
      });
    }

    if (_detectCycle(inDegrees)) {}
    return ordered;
  }

  bool _detectCycle(HashMap<E, int> inDegrees) {
    return inDegrees.values.where((element) => element > 0).isNotEmpty;
  }

  @override
  bool moveNext() {
    if (trees.isNotEmpty) {
      _currentElement = trees.removeAt(0);
      return true;
    }
    return false;
  }
}
