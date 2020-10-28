import 'package:mockito/mockito.dart';
import 'package:parabeac_core/input/sketch/entities/layers/abstract_group_layer.dart';
import 'package:parabeac_core/input/sketch/entities/layers/abstract_layer.dart';
import 'package:parabeac_core/input/sketch/entities/objects/frame.dart';
import 'package:parabeac_core/input/sketch/entities/style/style.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/inherited_container.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_layout_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_visual_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_context.dart';
import 'package:parabeac_core/interpret_and_optimize/services/pb_visual_generation_service.dart';
import 'package:test/test.dart';

class MockSketchNode extends Mock implements SketchNode {
  // @override
  // Future<PBIntermediateNode> interpretNode(currentContext) =>
  //     Future.value(InheritedContainer(MockSketchNode(), null, null,
  //         currentContext: currentContext));
}

class ContextMock extends Mock implements PBContext {}

void main() {
  var mockRootSketchNode = MockSketchNode();
  var context = ContextMock();
  var vgs =
      PBVisualGenerationService(mockRootSketchNode, currentContext: context);
  var mockOriginalRef = MockSketchNode();

  PBIntermediateNode response;
  setUpAll(() {
    when(mockRootSketchNode.isVisible).thenReturn(true);
    when(mockRootSketchNode.name).thenReturn('testing Name');
    when(mockOriginalRef.boundaryRectangle)
        .thenReturn(Frame(width: 50, height: 50, x: 0, y: 0));
    when(mockOriginalRef.style).thenReturn(Style(fills: []));
    when(mockRootSketchNode.interpretNode(context)).thenAnswer((_) =>
        Future.value(InheritedContainer(mockOriginalRef, null, null, 'testName',
            currentContext: context)));
  });
  test('Should generate IntermediateTree', () async {
    response = await vgs.getIntermediateTree();
    expect(response, isNotNull);
  });

  // test('VisualGenerationService should not produce any alignment nodes.', (){
  //   var queue = <PBIntermediateNode>[];
  //   queue.add(response);
  //   while(queue.isNotEmpty){

  //   }
  // });

  /// This test relies on previous tests running.
  test(
      'PBIntermediateNode Tree depth should be the same as the original sketch node tree depth',
      () {
    var queue = <_DepthTuple>[];
    var sketchNodeDepth = 0;
    var intermediateNodeDepth = 0;

    /// Calculate Depth of Sketch Node Tree
    queue.add(_DepthTuple(0, mockRootSketchNode));
    while (queue.isNotEmpty) {
      var currentNode = queue.removeAt(0);
      if (currentNode.node is AbstractGroupLayer &&
          (currentNode.node as AbstractGroupLayer).children.isNotEmpty) {
        for (var child in (currentNode.node as AbstractGroupLayer).children) {
          if (currentNode.depth + 1 > sketchNodeDepth) {
            sketchNodeDepth = currentNode.depth + 1;
          }
          queue.add(_DepthTuple(currentNode.depth + 1, child));
        }
      }
    }

    /// Calculate Depth of Intermediate Node Tree
    queue.add(_DepthTuple(0, response));
    while (queue.isNotEmpty) {
      var currentNode = queue.removeAt(0);
      if (currentNode.node is PBVisualIntermediateNode) {
        if ((currentNode.node as PBVisualIntermediateNode).child != null) {
          if (currentNode.depth + 1 > intermediateNodeDepth) {
            intermediateNodeDepth = currentNode.depth + 1;
          }
          queue.add(_DepthTuple(currentNode.depth + 1,
              (currentNode.node as PBVisualIntermediateNode).child));
        } else if (currentNode.node is PBLayoutIntermediateNode) {
          if (currentNode.depth + 1 > intermediateNodeDepth) {
            intermediateNodeDepth = currentNode.depth + 1;
          }
          for (var child
              in (currentNode.node as PBLayoutIntermediateNode).children) {
            queue.add(_DepthTuple(currentNode.depth + 1, child));
          }
        }
      }
    }
    expect(sketchNodeDepth, intermediateNodeDepth);
  });
}

class _DepthTuple {
  final int depth;
  final Object node;
  _DepthTuple(this.depth, this.node);
}
