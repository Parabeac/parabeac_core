import 'dart:io';
import 'package:parabeac_core/controllers/main_info.dart';
import 'package:parabeac_core/generation/flutter_project_builder/flutter_project_builder.dart';
import 'package:parabeac_core/generation/generators/layouts/pb_scaffold_gen.dart';
import 'package:parabeac_core/generation/generators/util/pb_generation_project_data.dart';
import 'package:parabeac_core/generation/generators/util/pb_generation_view_data.dart';
import 'package:parabeac_core/generation/generators/value_objects/file_structure_strategy/flutter_file_structure_strategy.dart';
import 'package:parabeac_core/generation/generators/value_objects/file_structure_strategy/pb_file_structure_strategy.dart';
import 'package:parabeac_core/generation/generators/visual-widgets/pb_container_gen.dart';
import 'package:parabeac_core/generation/generators/writers/pb_flutter_writer.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/inherited_container.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/inherited_scaffold.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_context.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_intermediate_node_tree.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_project.dart';
import 'package:parabeac_core/interpret_and_optimize/state_management/intermediate_auxillary_data.dart';
import 'package:test/test.dart';
import 'package:mockito/mockito.dart';

class MockIntermediateTree extends Mock implements PBIntermediateTree {}

class MockScaffold extends Mock implements InheritedScaffold {}

class MockContainer extends Mock implements InheritedContainer {}

class MockProject extends Mock implements PBProject {}

class MockData extends Mock implements IntermediateAuxiliaryData {}

class MockContext extends Mock implements PBContext {}

void main() {
  group('Project Builder Test', () {
    var projectBuilder;

    var outputPath =
        '${Directory.current.path}/test/lib/output_services/temp2/';

    MockIntermediateTree intermediateTree;

    MockScaffold scaffold;

    MockContainer container;

    MockProject project;

    PBContainerGenerator containerGenerator;

    PBScaffoldGenerator scaffoldGenerator;

    MockData mockData;

    FileStructureStrategy fss;

    MockContext context;

    setUp(() async {
      MainInfo().cwd = Directory.current;
      MainInfo().outputPath =
          '${Directory.current.path}/test/lib/output_services/';

      project = MockProject();
      intermediateTree = MockIntermediateTree();
      scaffold = MockScaffold();
      container = MockContainer();
      mockData = MockData();
      context = MockContext();

      containerGenerator = PBContainerGenerator();
      scaffoldGenerator = PBScaffoldGenerator();

      MainInfo().configurations = {'state-management': 'none'};

      when(intermediateTree.rootNode).thenReturn(scaffold);
      when(intermediateTree.name).thenReturn('testTree');
      when(intermediateTree.data).thenReturn(PBGenerationViewData());

      when(project.projectName).thenReturn(
          '${Directory.current.path}/test/lib/output_services/temp2/');
      when(project.forest).thenReturn([intermediateTree]);
      when(project.genProjectData).thenReturn(PBGenerationProjectData());
      when(project.projectAbsPath).thenReturn(outputPath);
      when(project.genProjectData).thenReturn(PBGenerationProjectData());

      when(context.project).thenReturn(project);

      when(scaffold.child).thenReturn(container);
      when(scaffold.isHomeScreen).thenReturn(false);
      when(scaffold.generator).thenReturn(scaffoldGenerator);
      when(scaffold.name).thenReturn('testingPage');
      when(scaffold.managerData).thenReturn(PBGenerationViewData());
      when(scaffold.auxiliaryData).thenReturn(mockData);
      when(scaffold.currentContext).thenReturn(context);

      when(container.generator).thenReturn(containerGenerator);
      when(container.auxiliaryData).thenReturn(mockData);
      when(container.managerData).thenReturn(PBGenerationViewData());

      fss =
          FlutterFileStructureStrategy(outputPath, PBFlutterWriter(), project);
      await fss.setUpDirectories();
      when(project.fileStructureStrategy).thenReturn(fss);

      projectBuilder = FlutterProjectBuilder(
          projectName: outputPath,
          mainTree: project,
          pageWriter: PBFlutterWriter());
    });
    test(
      '',
      () async {
        /// Check that the Dart file was created
        /// It should be a file named `testingPage`
        /// Stafefulwidget with a Scaffold and a Container
        await projectBuilder.convertToFlutterProject();
      },
      timeout: Timeout(
        Duration(minutes: 1),
      ),
    );
    tearDownAll(() {
      Process.runSync('rm', ['-rf', '$outputPath']);
    });
  });
}
