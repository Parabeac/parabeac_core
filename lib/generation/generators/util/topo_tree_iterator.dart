import 'dart:collection';

import 'package:parabeac_core/interpret_and_optimize/helpers/pb_intermediate_node_tree.dart';

///Iterating through the screens in a manner where, the screens that are
///dependent are processed first.
///
///  Make sure there are no cycles in the graph. "In a dependency graph,
///  the cycles of dependencies (also called circular dependencies) lead to a situation in which no valid evaluation order exists,
///  because none of the objects in the cycle may be evaluated first."
///  * If cycles are detected in the list, then a [CyclicDependencyError] is going to be thrown.
///
///For example, assyme we have the following dependency graph:
/// `tree1` is going to depend on `tree0` and `tree0` depends on `tree2`.
///   t1 --> t0 --> t2
/// The correct order should be: `[t2, t0, t1]`,
/// because t2 has dependets, therefore, it needs to be processed first.
class IntermediateTopoIterator<E extends PBIntermediateTree>
    implements Iterator<E> {
  List<E> trees;

  E _currentElement;

  @override
  E get current => _currentElement;

  IntermediateTopoIterator(this.trees) {
    trees = topologicalSort(trees);
    if (trees.isNotEmpty) {
      trees = List.from(trees.reversed);
      _currentElement = trees[0];
    }
  }

  ///Calculating the in-degrees that are comming in to a [PBIntermediateTree].
  ///
  ///Its traversing each of the [PBIntermediateTree] in the [items], documenting
  ///that the in-degrees of each of the nodes.
  HashMap<E, int> _inDegrees(List<PBIntermediateTree> items) {
    var inDegree = HashMap<E, int>();
    items.forEach((tree) {
      inDegree.putIfAbsent(tree, () => 0);
      var dependentOnIterator = tree.dependentOn;
      while (dependentOnIterator.moveNext()) {
        inDegree.update(dependentOnIterator.current, (value) => value + 1,
            ifAbsent: () => 1);
      }
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
      var it = vertex.dependentOn;
      while (it.moveNext()) {
        inDegrees[it.current] = inDegrees[it.current] - 1;
        if (inDegrees[it.current] == 0) {
          noInDegrees.add(it.current);
        }
      }
    }

    if (_detectCycle(inDegrees)) {
      throw CyclicDependencyError(trees);
    }
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

/// Error thrown when there is a cycle in the dependency graph of [PBIntermediateTree]
class CyclicDependencyError extends Error {
  List items;
  CyclicDependencyError([this.items]);
  @override
  String toString() {
    var message = 'Cycle Detected on Graph';
    if (items != null) {
      message += '. Graph: ${items.toString()}';
    }
    return message;
  }
}
