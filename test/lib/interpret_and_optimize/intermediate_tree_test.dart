import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_intermediate_node_tree.dart';
import 'package:test/test.dart';
import 'package:mockito/mockito.dart';

class MockContainer extends Mock implements PBIntermediateNode {}

class MockContainerBuilder {
  static MockContainer buildContainer(String UUID,
      {List<PBIntermediateNode> children, MockContainer parent}) {
    var container = MockContainer();
    when(container.UUID).thenReturn(UUID);
    when(container.children).thenReturn(children);
    when(container.parent).thenReturn(parent);
    return container;
  }
}

class TreeBuilder<T extends PBIntermediateNode> {
  num numberOfContainers;
  List<T> _containerList;
  T rootNode;

  var nodeBuilder;
  var rootNodeBuilder;

  TreeBuilder(this.numberOfContainers,
      {T Function(int index) this.nodeBuilder,
      T Function(List<T> children, T rootNode) this.rootNodeBuilder}) {
    nodeBuilder ??= _mockContainerBuilder;
    rootNodeBuilder ??= _rootNodeBuilder;
  }

  T _mockContainerBuilder(int idx, T rootNode) {
    var container = MockContainer();

    var containerChild = MockContainer();
    when(containerChild.UUID).thenReturn(('C_$idx'));
    when(containerChild.parent).thenReturn(container);

    when(container.children).thenReturn([containerChild]);
    when(container.UUID).thenReturn('P_$idx');
    when(container.parent).thenReturn(rootNode);

    return container as T;
  }

  T _rootNodeBuilder() {
    var rootNode = MockContainer();
    when(rootNode.UUID).thenReturn('R_123');
    return rootNode as T;
  }

  PBIntermediateTree build() {
    rootNode = rootNodeBuilder();
    _containerList = List<T>.generate(
        (numberOfContainers ~/ 2), (index) => nodeBuilder(index, rootNode));
    when(rootNode.children).thenReturn(_containerList);

    var tree = PBIntermediateTree(name: 'Example');
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

    test('Replacement of nodes in [$PBIntermediateNode]', () {
      var replacementChild3 = MockContainerBuilder.buildContainer(
          'REPLACEMENT_C3',
          parent: null,
          children: []);
      var parentReplacement4 = MockContainerBuilder.buildContainer(
          'REPLACEMENT_P4',
          parent: null,
          children: []);
      var find = (UUID) =>
          tree.firstWhere((node) => node.UUID == UUID, orElse: () => null);

      var targetChild3 = find('C_3');
      var targetParent4 = find('P_4');
      var targetChild4 = find('C_4');

      expect(targetChild3, isNotNull);
      expect(targetParent4, isNotNull);

      expect(tree.replaceNode(targetChild3, replacementChild3), isTrue);
      expect(find(targetChild3.UUID), isNull);

      expect(
          tree.replaceNode(targetParent4, parentReplacement4,
              acceptChildren: true),
          isTrue);
      expect(find(targetParent4.UUID), isNull);
      expect(find(targetChild4.UUID), isNotNull,
          reason:
              'The ${targetChild4.UUID} is not part of the $parentReplacement4 children');

      // reset(rootNode);
      // reset(containerList);
    });

    test('Testing the removal of nodes from the tree', () {
      var child3 = tree.firstWhere((child) => child.UUID == 'C_3');
      var parent4 = tree.firstWhere((parent) => parent.UUID == 'P_4');
      var child4 = tree.firstWhere((child) => child.UUID == 'C_4');

      expect(child3, isNotNull);
      expect(parent4, isNotNull);
      expect(child4, isNotNull);

      expect(tree.removeNode(child3), isTrue);
      expect(
          tree.firstWhere((child) => child.UUID == child3.UUID,
              orElse: () => null),
          isNull);

      expect(tree.removeNode(parent4, eliminateSubTree: true), isTrue);
      expect(
          tree.firstWhere((parent) => parent.UUID == parent4.UUID,
              orElse: () => null),
          isNull);
      expect(
          tree.firstWhere((child) => child.UUID == child4.UUID,
              orElse: () => null),
          isNull,
          reason:
              '${child4.UUID} should have been removed of the ${tree.runtimeType} as consequence of deleting its parent');
      // reset(rootNode);
      // reset(containerList);
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
