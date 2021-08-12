import 'package:parabeac_core/interpret_and_optimize/helpers/pb_intermediate_node_tree.dart';

/// Iterating the Intermediate Tree by DFS
class IntermediateDFSIterator<E extends TraversableNode>
    implements Iterator<E> {
  final PBIntermediateTree _tree;

  E _currentElement;

  List<E> _stack;

  IntermediateDFSIterator(this._tree, {E startingNode}) {
    var initNode = startingNode ?? _tree.rootNode;
    if (initNode == null) {
      throw NullThrownError();
    }
    _stack = [initNode];
  }
  @override
  bool moveNext() {
    if (_stack.isNotEmpty) {
      _currentElement = _stack.removeAt(0);
      _stack.addAll((_currentElement?.children ?? []).cast<E>());
      return true;
    }
    return false;
  }

  @override
  E get current => _currentElement;
}
