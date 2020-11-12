import 'dart:io';
import 'package:parabeac_core/controllers/main_info.dart';
import 'package:parabeac_core/generation/flutter_project_builder/flutter_project_builder.dart';
import 'package:parabeac_core/generation/generators/layouts/pb_scaffold_gen.dart';
import 'package:parabeac_core/generation/generators/visual-widgets/pb_container_gen.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/inherited_container.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/inherited_scaffold.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_intermediate_group.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_intermediate_item.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_intermediate_node_tree.dart';
import 'package:test/test.dart';
import 'package:mockito/mockito.dart';

class MockIntermediateTree extends Mock implements PBIntermediateTree {}

class MockIntermediateGroup extends Mock implements PBIntermediateGroup {}

class MockIntermediateItem extends Mock implements PBIntermediateItem {}

class MockScaffold extends Mock implements InheritedScaffold {}

class MockContainer extends Mock implements InheritedContainer {}

void main() {
  group('Project Builder Test', () {
    var projectBuilder;

    var outputPath = '${Directory.current.path}/test/lib/output_services/temp2';

    MockIntermediateTree intermediateTree;

    MockIntermediateGroup intermediateGroup;

    MockIntermediateItem intermediateItem;

    MockScaffold scaffold;

    MockContainer container;

    PBContainerGenerator containerGenerator;

    PBScaffoldGenerator scaffoldGenerator;

    setUp(() async {
      MainInfo().cwd = Directory.current;
      MainInfo().outputPath =
          '${Directory.current.path}/test/lib/output_services/';

      intermediateTree = MockIntermediateTree();
      intermediateGroup = MockIntermediateGroup();
      intermediateItem = MockIntermediateItem();
      scaffold = MockScaffold();
      container = MockContainer();

      containerGenerator = PBContainerGenerator();
      scaffoldGenerator = PBScaffoldGenerator();

      when(intermediateTree.groups).thenReturn([intermediateGroup]);

      when(intermediateGroup.items).thenReturn([intermediateItem]);
      when(intermediateGroup.name).thenReturn('intermediateTest');

      when(intermediateItem.node).thenReturn(scaffold);

      when(scaffold.child).thenReturn(container);
      when(scaffold.isHomeScreen).thenReturn(false);
      when(scaffold.generator).thenReturn(scaffoldGenerator);
      when(scaffold.name).thenReturn('testingPage');

      when(container.generator).thenReturn(containerGenerator);

      projectBuilder = await FlutterProjectBuilder(
          projectName: outputPath, mainTree: intermediateTree);
    });
    test('', () async {
      /// Check that the Dart file was created
      /// It should be a file named `testingPage`
      /// Stafefulwidget with a Scaffold and a Container
      await projectBuilder.convertToFlutterProject();
    });
    tearDownAll(() {
      Process.runSync('rm', ['-rf', '$outputPath']);
    });
  });
}
