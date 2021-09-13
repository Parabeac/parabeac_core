import 'dart:math';

import 'package:mockito/mockito.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/inherited_container.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/inherited_text.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/layouts/rules/stack_reduction_visual_rule.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/layouts/stack.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
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

void main() {
  var stack;
  var textNode;
  var container, container2;

  group('Layout post rules tests', () {
    setUp(() {
      stack = StackMock();
      textNode = TextMock();
      container = InheritedContainerMockWrapper();
      container2 = InheritedContainerMock();

      // Set up stack Hierarchy:
      // * Stack
      //     * container
      //     * container2
      //          * textNode
      when(stack.children)
          .thenReturn(<PBIntermediateNode>[container, container2]);
      when(container2.child).thenReturn(textNode);

      // Set up coordinates so container2 is inside container
      when(container.bottomRightCorner).thenReturn(Point(40, 40));
      when(container.topLeftCorner).thenReturn(Point(0, 0));
      when(container2.topLeftCorner).thenReturn(Point(10, 10));
      when(container2.bottomRightCorner).thenReturn(Point(30, 30));
    });

    test('Testing stack reduction visual rule', () {
      var stackReduction = StackReductionVisualRule();

      var passedRule = stackReduction.testRule(stack, null);

      expect(passedRule, true);

      var result = stackReduction.executeAction(stack, null);

      // Expect the following hierarchy:
      // * Container
      //     * Container
      //         * Text
      expect(result, isA<InheritedContainer>());
      expect(result.child, isA<InheritedContainer>());
      expect(result.child.child, isA<InheritedText>());
    });
  });
}
