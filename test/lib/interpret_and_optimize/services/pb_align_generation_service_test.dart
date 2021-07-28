import 'dart:math';

import 'package:mockito/mockito.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/alignments/injected_positioned.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/injected_container.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/layouts/stack.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_constraints.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/align_strategy.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/child_strategy.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_configuration.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_context.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_intermediate_node_tree.dart';
import 'package:parabeac_core/interpret_and_optimize/services/pb_alignment_generation_service.dart';
import 'package:test/test.dart';
import 'package:uuid/uuid.dart';

import '../dfs_iterator_test.dart';

class MockContext extends Mock implements PBContext {}

class MockContainer extends Mock implements InjectedContainer {}

var containerList;
PBIntermediateTree tree;
PBAlignGenerationService alignGenerationService;
PBContext context;

void main() {
  group('Testing the Positions generated for stacks', () {
    PBIntermediateStackLayout stack;
    setUp(() {
      context = PBContext(null);

      tree = TreeBuilder(10, nodeBuilder: (index) {

        /// Constructing the [PBIntermediateTree] with real [InjectedContainer] rather than
        /// using the [Mock]
        var origin = Point(0, 0);
        var container = InjectedContainer(
            origin, origin, 'P_$index', 'P_$index',
            constraints: PBIntermediateConstraints());
        container.childrenStrategy = OneChildStrategy('child');

        var containerChild = InjectedContainer(
            origin, origin, 'C_$index', 'C_$index',
            constraints: PBIntermediateConstraints());
        containerChild.childrenStrategy = OneChildStrategy('child');

        container.addChild(containerChild);
        return container;
      }, rootNodeBuilder: (children) {

        /// Constructing a real [InjectedContainer] as [PBIntermediateTree.rootNode] rather
        /// than using a [Mock]
        var rootNode = PBIntermediateStackLayout(context);
        rootNode.constraints = PBIntermediateConstraints();
        rootNode.alignStrategy = NoAlignment();

        rootNode.replaceChildren(children);
        return rootNode;
      }).build();

      context.tree = tree;
      alignGenerationService = PBAlignGenerationService();
    });

    test(
        'When given a node contains contraints that are inheritable after [PBAlignGenerationService]',
        () {
      var inheritedFixedHeight = 2.0;
      var inheritedFixedWidth = 3.0;

      var parent = tree.firstWhere((child) => child?.UUID == 'P_0');
      parent.constraints.fixedHeight = inheritedFixedHeight;
      parent.constraints.fixedWidth = inheritedFixedWidth;
      alignGenerationService.addAlignmentToLayouts(tree, context);


      var inheritedConstrainsChild0 =
          tree.firstWhere((child) => child.UUID == 'C_0');
      var nonInheritedConstrainsChild =
          tree.firstWhere((child) => child.UUID == 'C_1');

      expect(inheritedConstrainsChild0.constraints.fixedHeight,
          inheritedFixedHeight);
      expect(
          inheritedConstrainsChild0.constraints.fixedWidth, inheritedFixedWidth);
      expect(nonInheritedConstrainsChild.constraints.fixedHeight, isNull);
      expect(nonInheritedConstrainsChild.constraints.fixedWidth, isNull);
    });
  });
}
