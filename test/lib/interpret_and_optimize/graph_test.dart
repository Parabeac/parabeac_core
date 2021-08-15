import 'package:directed_graph/directed_graph.dart';
import 'package:mockito/mockito.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/inherited_circle.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/inherited_container.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/inherited_scaffold.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/injected_container.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_intermediate_node_tree.dart';
import 'package:test/test.dart';

// import '../output_services/project_builder_test.dart';

class MockContainer extends Mock implements InjectedContainer {}

class MockScaffold extends Mock implements InheritedScaffold {}

void main() {
  group('Testing IntermediateTree', () {
    PBIntermediateTree tree;
    setUp(() {
      tree = PBIntermediateTree(
          comparator: (v0, v1) => v0.data.UUID.compareTo(v1.data.UUID));
    });

    test('', () {
      var parent = InheritedContainer('PARENT', null);
      var child = InheritedCircle('CHILD', null);

      // var vParent =;
      // var vChild = ;

      tree.addEdges(AITVertex(parent), [AITVertex(child)]);
      print(tree);
      var edges = tree.edges(AITVertex(parent));
      print(tree);
    });
  });
}
