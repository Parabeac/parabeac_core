import 'package:mockito/mockito.dart';
import 'package:parabeac_core/generation/flutter_project_builder/import_helper.dart';
import 'package:parabeac_core/generation/generators/util/topo_tree_iterator.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_gen_cache.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_intermediate_node_tree.dart';
import 'package:test/test.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';

class NodeMock extends Mock implements PBIntermediateNode {}

void main() {
  // Will test IntermediateNode that needs imports
  // and an IntermediateNode without imports
  var iNodeWithImports, iNodeWithoutImports;

  /// Three intermediateNodes that will generate import
  var importee1, importee2, importee3;
  var genCache;

  PBIntermediateTree tree0, tree1, tree2;
  group('Import test', () {
    setUp(() {
      iNodeWithImports = NodeMock();
      iNodeWithoutImports = NodeMock();
      importee1 = NodeMock();
      importee2 = NodeMock();
      importee3 = NodeMock();
      genCache = PBGenCache();

      tree0 = PBIntermediateTree('Tree0');
      tree1 = PBIntermediateTree('Tree1');
      tree2 = PBIntermediateTree('Tree2');

      when(iNodeWithImports.UUID).thenReturn('00-00-00');
      when(iNodeWithoutImports.UUID).thenReturn('00-01-00');
      when(importee1.UUID).thenReturn('00-00-01');
      when(importee2.UUID).thenReturn('00-00-02');
      when(importee3.UUID).thenReturn('00-00-03');

      when(iNodeWithImports.child).thenReturn(importee1);
      when(importee1.child).thenReturn(importee2);
      when(importee2.child).thenReturn(importee3);
    });

    test('Testing how [PBIntermediateTree] are processed.', () {
      ///[PBIntermediateTree]s that are going to be generated. The treees inside of the list
      ///are dependent on each other, therefore, to ensure import availability, trees need to
      ///be written in a certain manner.
      var pbIntermeidateTrees = <PBIntermediateTree>[];

      /// `tree1` is going to depend on `tree0` and `tree0` depends on `tree2`.
      ///    ?t0?
      ///   /   \
      /// t1      t2
      tree1.addDependent(tree0);
      tree0.addDependent(tree2);
      pbIntermeidateTrees.addAll([tree0, tree2, tree1]);

      var dependencyIterator =
          IntermediateTopoIterator<PBIntermediateTree>(pbIntermeidateTrees);
      var correctOrder = [tree1, tree0, tree2].iterator;
      while (dependencyIterator.moveNext() && correctOrder.moveNext()) {
        expect(dependencyIterator.current == correctOrder.current, true);
      }
    });

    test('Testing cycles in the list [PBIntermediateTree] are processed', () {
      ///[PBIntermediateTree]s that are going to be generated. The treees inside of the list
      ///are dependent on each other, therefore, to ensure import availability, trees need to
      ///be written in a certain manner.
      var pbIntermeidateTrees = <PBIntermediateTree>[];

      /// a cycle between all three [PBIntermediateTree]s
      ///     t0
      ///   /   \
      /// t1----?t2
      tree1.addDependent(tree0);
      tree0.addDependent(tree2);
      tree2.addDependent(tree2);
      pbIntermeidateTrees.addAll([tree0, tree2, tree1]);

      var dependencyIterator =
          IntermediateTopoIterator<PBIntermediateTree>(pbIntermeidateTrees);
      var correctOrder = [tree1, tree0, tree2].iterator;
      while (dependencyIterator.moveNext() && correctOrder.moveNext()) {
        expect(dependencyIterator.current == correctOrder.current, true);
      }
    });

    test('Testing import generation when imports are generated', () {
      //Add symbol in the same folder as importer
      genCache.setPathToCache(importee1.UUID, '/path/to/page/importee1.dart');
      //Add symbol located a directory above importer
      genCache.setPathToCache(importee2.UUID, '/path/to/importee2.dart');
      //Add symbol located a directory below importer
      genCache.setPathToCache(
          importee3.UUID, '/path/to/page/sub/importee3.dart');

      // Find the imports of importer.dart
      var imports = ImportHelper.findImports(
          iNodeWithImports, '/path/to/page/importer.dart');

      expect(imports.length, 3);
      expect(imports.contains('./importee1.dart'), true);
      expect(imports.contains('../importee2.dart'), true);
      expect(imports.contains('./sub/importee3.dart'), true);
    });

    test('Testing import generation when no imports are generated', () {
      var noImports = ImportHelper.findImports(
          iNodeWithoutImports, '/path/to/page/not_importer.dart');
      expect(noImports.length, 0);
    });
  });
}
