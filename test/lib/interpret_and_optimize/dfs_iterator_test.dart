import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_intermediate_node_tree.dart';
import 'package:test/test.dart';
import 'package:mockito/mockito.dart';

class MockContainer extends Mock implements PBIntermediateNode {}

class TreeBuilder<T extends PBIntermediateNode> {
  num numberOfContainers;
  List<T> _containerList;
  T rootNode;

  var nodeBuilder;
  var rootNodeBuilder;

  TreeBuilder(this.numberOfContainers,
      {T Function(int index) this.nodeBuilder,
      T Function(List<T> children) this.rootNodeBuilder}) {
    nodeBuilder ??= _mockContainerBuilder;
    rootNodeBuilder ??= _rootNodeBuilder;
  }

  T _mockContainerBuilder(int idx) {
    var container = MockContainer();

    var containerChild = MockContainer();
    when(containerChild.UUID).thenReturn(('C_$idx'));

    when(container.children).thenReturn([containerChild]);
    when(container.UUID).thenReturn('P_$idx');
    return container as T;
  }

  T _rootNodeBuilder(List<T> children) {
    var rootNode = MockContainer();
    when(rootNode.UUID).thenReturn('R_123');
    when(rootNode.children).thenReturn(_containerList);
    return rootNode as T;
  }

  PBIntermediateTree build() {
    _containerList = List<T>.generate((numberOfContainers ~/ 2), nodeBuilder);
    rootNode = rootNodeBuilder(_containerList);

    var tree = PBIntermediateTree('Example');
    tree.rootNode = rootNode;

    ///Taking into account the [rootNode]
    numberOfContainers++;
    return tree;
  }
}

void main() {
  var numberOfContainers;
  var rootNode;
  TreeBuilder treeBuilder;
  PBIntermediateTree tree;
  group('Testing the PBIntermediateTree', () {
    setUp(() {
      ///This is the tree that is going to be build:
      ///       [R_123]
      ///         |
      /// [P_0, P_1, P_2, P_3, P_4]
      ///   |    |    |    |    |
      /// [C_0][C_1][C_2][C_3][C_4]
      /// 

      numberOfContainers = 10;
      treeBuilder = TreeBuilder(numberOfContainers);
      tree = treeBuilder.build();
      rootNode = treeBuilder.rootNode;
    });

    test('Testing the traversal of the IntermediateTree', () {
      expect(tree.length, treeBuilder.numberOfContainers);
      expect(tree.first, rootNode);
    });

    test(
        'Testing [PBIntermediateTree.dist] function, see if it gives the correct distance between two nodes',
        () {
      var child = tree.firstWhere((node) => node.UUID == 'C_0');
      expect(child, isNotNull);
      expect(tree.depthOf(child), 2);

      var parent = tree.firstWhere((node) => node.UUID == 'P_0');
      expect(parent, isNotNull);
      expect(tree.depthOf(parent), 1);

      expect(rootNode, isNotNull);
      expect(tree.depthOf(rootNode), 0);
    });
  });
}
