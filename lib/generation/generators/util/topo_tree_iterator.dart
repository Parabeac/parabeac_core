import 'dart:collection';

import 'package:parabeac_core/interpret_and_optimize/helpers/pb_intermediate_node_tree.dart';

///Iterating through the screens in a manner where, the screens that are
///dependent are processed first.
///
///For example, assyme we have the following dependency graph:
///     t0
///   /   \
/// t1      t2
/// `tree1` is going to depend on `tree0` and `tree0` depends on `tree2`.
/// We should traverse the graph first processing `t1`, then `t0`, and finally `t2`.
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
