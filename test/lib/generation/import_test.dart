import 'dart:io';

import 'package:mockito/mockito.dart';
import 'package:parabeac_core/generation/flutter_project_builder/import_helper.dart';
import 'package:parabeac_core/generation/generators/util/topo_tree_iterator.dart';
import 'package:parabeac_core/generation/generators/value_objects/file_structure_strategy/commands/write_screen_command.dart';
import 'package:parabeac_core/generation/generators/value_objects/file_structure_strategy/flutter_file_structure_strategy.dart';
import 'package:parabeac_core/generation/generators/value_objects/file_structure_strategy/pb_file_structure_strategy.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_intermediate_node_tree.dart';
import 'package:test/test.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';

class NodeMock extends Mock implements PBIntermediateNode {}

class FileStructureStrategyMock extends Mock implements FileStructureStrategy {}

class FileMock extends Mock implements File {}

void main() {
  group('[PBIntermediateTree] process order test', () {
    PBIntermediateTree tree0, tree1, tree2;
    setUp(() {
      tree0 = PBIntermediateTree('Tree0');
      tree0.rootNode = NodeMock();
      when(tree0.rootNode.UUID).thenReturn('00-00-01');
      when(tree0.rootNode.name).thenReturn('Tree0');

      tree1 = PBIntermediateTree('Tree1');
      tree1.rootNode = NodeMock();
      when(tree1.rootNode.UUID).thenReturn('00-00-02');
      when(tree1.rootNode.name).thenReturn('Tree1');

      tree2 = PBIntermediateTree('Tree2');
      tree2.rootNode = NodeMock();
      when(tree2.rootNode.UUID).thenReturn('00-00-03');
      when(tree2.rootNode.name).thenReturn('Tree2');
    });
    test('Testing how [PBIntermediateTree] are processed.', () {
      ///[PBIntermediateTree]s that are going to be generated. The treees inside of the list
      ///are dependent on each other, therefore, to ensure import availability, trees need to
      ///be written in a certain manner.
      var pbIntermeidateTrees = <PBIntermediateTree>[];

      /// `tree1` is going to depend on `tree0` and `tree0` depends on `tree2`.
      ///   t1 --> t0 --> t2
      /// The correct order should be: `[t2, t0, t1]`,
      /// because t2 has dependets, therefore, it needs to be processed first.
      tree1.addDependent(tree0);
      tree0.addDependent(tree2);

      //The initial order should't manner the end result
      pbIntermeidateTrees.addAll([tree0, tree2, tree1]);

      var dependencyIterator =
          IntermediateTopoIterator<PBIntermediateTree>(pbIntermeidateTrees);
      var correctOrder = [tree2, tree0, tree1].iterator;
      while (dependencyIterator.moveNext() && correctOrder.moveNext()) {
        expect(dependencyIterator.current == correctOrder.current, true,
            reason:
                'The [PBIntermediateTree]s are not being processed in the correct order in respect to their dependencies');
      }
    });

    test('Testing cycles in the list [PBIntermediateTree] are processed', () {
      ///[PBIntermediateTree]s that are going to be generated. The treees inside of the list
      ///are dependent on each other, therefore, to ensure import availability, trees need to
      ///be written in a certain manner.
      var pbIntermeidateTrees = <PBIntermediateTree>[];

      /// a cycle between all three [PBIntermediateTree]s
      ///
      ///
      /// `tree1` --> `tree0` --> `tree2`
      ///    <\          /
      ///       ----------
      tree1.addDependent(tree0);
      tree0.addDependent(tree2);
      tree0.addDependent(tree1);
      pbIntermeidateTrees.addAll([tree0, tree2, tree1]);

      expect(
          () =>
              IntermediateTopoIterator<PBIntermediateTree>(pbIntermeidateTrees),
          throwsA(isA<CyclicDependencyError>()),
          reason:
              '[CyclicDependencyError] is not being thrown when there is a cycle in the graph');
    });
  });
  group('Import paths extraction test', () {
    FileStructureStrategy _fileStructureStrategy;
    ImportHelper importHelper;
    var completePath =
        'desktop/project/lib/screens/homescreen/some_dart_page.dart';
    var genPath = 'desktop/project/';
    setUp(() {
      _fileStructureStrategy = FileStructureStrategyMock();
      importHelper = ImportHelper();

      when(_fileStructureStrategy.writeDataToFile(any, any, any,
              UUID: anyNamed('UUID')))
          .thenAnswer((invocation) {
        var dir = invocation.positionalArguments[1];
        var name = invocation.positionalArguments[2];
        var uuid = invocation.namedArguments['UUID'] ?? 'UUID';
        importHelper.fileCreated(
            FlutterFileStructureStrategy(genPath, null, null)
                .getFile(dir, name)
                .path,
            uuid);
      });
      when(_fileStructureStrategy.GENERATED_PROJECT_PATH).thenReturn(genPath);
    });
    test('Testing import generation when imports are generated', () async {
      var command = WriteScreenCommand(
          'UUID', 'some_dart_page.dart', 'homescreen/', 'dummy code');
      await command.write(_fileStructureStrategy);
      expect(importHelper.getImport('UUID'), completePath);
    });
  });
}
