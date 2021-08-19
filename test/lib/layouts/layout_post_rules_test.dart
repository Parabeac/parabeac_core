import 'dart:math';

import 'package:mockito/mockito.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/inherited_container.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/inherited_text.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/layouts/rules/stack_reduction_visual_rule.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/layouts/stack.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_context.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_intermediate_node_tree.dart';
import 'package:test/test.dart';

class InheritedContainerMockWrapper extends Mock implements InheritedContainer {
  @override
  var child;
  @override
  void addChild(node) {
    child = node;
  }
}

class InheritedContainerMock extends Mock implements InheritedContainer {}

class StackMock extends Mock implements PBIntermediateStackLayout {}

class TextMock extends Mock implements InheritedText {}

class MockPBContext extends Mock implements PBContext {}

class MockPBITree extends Mock implements PBIntermediateTree {}

void main() {
  var stack;
  var textNode;
  var container, container2;
  var mockPBContext;
  var mockTree;

  group('Layout post rules tests', () {
    setUp(() {
      stack = StackMock();
      textNode = TextMock();
      container = InheritedContainerMockWrapper();
      container2 = InheritedContainerMock();
      mockPBContext = MockPBContext();
      mockTree = MockPBITree();

      // Set up stack Hierarchy:
      // * Stack
      //     * container
      //     * container2
      //          * textNode

      when(mockPBContext.tree).thenReturn(mockTree);

      when(mockTree.childrenOf(any)).thenReturn(<PBIntermediateNode>[
        container,
        container2,
      ]);

      when(mockTree.childrenOf(container)).thenReturn(<PBIntermediateNode>[]);

      when(mockTree.childrenOf(container2))
          .thenReturn(<PBIntermediateNode>[textNode]);

      // Set up coordinates so container2 is inside container
      when(container.frame).thenReturn(Rectangle(0, 0, 40, 40));

      when(container2.frame).thenReturn(Rectangle(10, 10, 20, 20));
    });

    test('Testing stack reduction visual rule', () {
      var stackReduction = StackReductionVisualRule();

      var passedRule = stackReduction.testRule(mockPBContext, stack, null);

      expect(passedRule, true);

      var result = stackReduction.executeAction(mockPBContext, stack, null);

      // Expect the following hierarchy:
      // * Container
      //     * Container
      //         * Text
      expect(result, isA<InheritedContainer>());
      expect(mockTree.childrenOf(stack).first, isA<InheritedContainer>());
      expect(mockTree.childrenOf(container2).first, isA<InheritedText>());
    });
  });
}
