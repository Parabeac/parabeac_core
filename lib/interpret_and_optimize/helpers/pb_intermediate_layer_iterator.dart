import 'package:parabeac_core/interpret_and_optimize/helpers/pb_intermediate_node_tree.dart';

class IntermediateLayerIterator<E extends TraversableNode>
    implements Iterator<List<E>> {
  final PBIntermediateTree _tree;
  List<List<E>> _stack;

  @override
  List<E> get current => _current;
  List<E> _current;

  @override
  bool moveNext() {
    if (_stack.isNotEmpty) {
      _current = _stack.removeAt(0);
      _stack.add(_current
          .expand<E>((element) => element.children as Iterable<dynamic>));
      return true;
    }
    return false;
  }

  IntermediateLayerIterator(this._tree, {E starting}) {
    var initNode = starting ?? _tree.rootNode;
    if (initNode == null) {
      throw NullThrownError();
    }
    _stack = [
      [initNode]
    ];
  }
}
