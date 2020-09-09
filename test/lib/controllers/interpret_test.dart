import 'package:mockito/mockito.dart';
import 'package:parabeac_core/controllers/interpret.dart';
import 'package:parabeac_core/input/sketch/helper/sketch_node_tree.dart';
import 'package:test/test.dart';

class MockSketchNodeTree extends Mock implements SketchNodeTree {}

void main() {
  var interpret = Interpret();
  test('Interpret should instantiate', () {
    var nameOfProject = 'test Project';
    interpret = Interpret();
    interpret.init(nameOfProject);
    expect(interpret, isNotNull);
    expect(interpret.projectName, nameOfProject);
  });

  test('Should return a PBIntermediateTree from a SketchNodeTree', () {
    var intermediateTree = interpret.interpretAndOptimize(MockSketchNodeTree());
    expect(intermediateTree, isNotNull);
  });

  test('interpret and optimize method should return a PBIntermediateNode',
      () {});
}
