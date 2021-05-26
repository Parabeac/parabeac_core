import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_intermediate_node_tree.dart';
import 'package:test/test.dart';
import 'package:mockito/mockito.dart';

class MockContainer extends Mock implements PBIntermediateNode {}

void main() {
  var containerList;
  var numberOfContainers;
  var rootNode;
  PBIntermediateTree tree;
  group('Testing the PBIntermediateTree', () {
    setUp(() {
      numberOfContainers = 10;
      containerList = List.generate((numberOfContainers ~/ 2), (idx) {
        var container = MockContainer();

        var containerChild = MockContainer();
        when(containerChild.UUID).thenReturn(('C_$idx'));

        when(container.children).thenReturn([containerChild]);
        when(container.UUID).thenReturn('P_$idx');
        return container;
      });

      rootNode = MockContainer();
      when(rootNode.UUID).thenReturn('R_123');
      when(rootNode.children).thenReturn(containerList);

      tree = PBIntermediateTree('Example');
      tree.rootNode = rootNode;

      ///Taking into account the [rootNode]
      numberOfContainers++;
    });

    test('Testing the traversal of the IntermediateTree', () {
      expect(tree.length, numberOfContainers);
      expect(tree.first, rootNode);
    });
  });
}
