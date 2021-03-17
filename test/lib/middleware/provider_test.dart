import 'dart:io';
import 'package:mockito/mockito.dart';
import 'package:parabeac_core/generation/generators/middleware/state_management/provider_middleware.dart';
import 'package:parabeac_core/generation/generators/pb_generation_manager.dart';
import 'package:parabeac_core/generation/generators/pb_generator.dart';
import 'package:parabeac_core/generation/generators/util/pb_generation_project_data.dart';
import 'package:parabeac_core/generation/generators/util/pb_generation_view_data.dart';
import 'package:parabeac_core/generation/generators/value_objects/file_structure_strategy.dart/provider_file_structure_strategy.dart';
import 'package:parabeac_core/generation/generators/writers/pb_flutter_writer.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_context.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_intermediate_node_tree.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_project.dart';
import 'package:parabeac_core/interpret_and_optimize/state_management/directed_state_graph.dart';
import 'package:parabeac_core/interpret_and_optimize/state_management/intermediate_auxillary_data.dart';
import 'package:parabeac_core/interpret_and_optimize/state_management/intermediate_state.dart';
import 'package:parabeac_core/interpret_and_optimize/state_management/intermediate_variation.dart';
import 'package:test/test.dart';

class MockPBGenerationManager extends Mock implements PBGenerationManager {}

class MockPBIntermediateNode extends Mock implements PBIntermediateNode {}

class MockContext extends Mock implements PBContext {}

class MockProject extends Mock implements PBProject {}

class MockPBGenerationProjectData extends Mock
    implements PBGenerationProjectData {}

class MockPBGenerationViewData extends Mock implements PBGenerationViewData {}

class MockPBGenerator extends Mock implements PBGenerator {}

class MockIntermediateAuxiliaryData extends Mock
    implements IntermediateAuxiliaryData {}

class MockDirectedStateGraph extends Mock implements DirectedStateGraph {}

class MockIntermediateState extends Mock implements IntermediateState {}

class MockIntermediateVariation extends Mock implements IntermediateVariation {}

class MockTree extends Mock implements PBIntermediateTree {}

void main() {
  group('Middlewares Tests', () {
    var testingPath = '${Directory.current.path}/test/lib/middleware/';
    var mockPBGenerationManager = MockPBGenerationManager();
    var providerMiddleware = ProviderMiddleware(mockPBGenerationManager);
    var node = MockPBIntermediateNode();
    var node2 = MockPBIntermediateNode();
    var mockContext = MockContext();
    var mockProject = MockProject();
    var mockPBGenerationProjectData = MockPBGenerationProjectData();
    var mockPBGenerationViewData = MockPBGenerationViewData();
    var mockPBGenerator = MockPBGenerator();
    var providerFileStructureStrategy = ProviderFileStructureStrategy(
      testingPath,
      PBFlutterWriter(),
      mockProject,
    );
    var mockIntermediateAuxiliaryData = MockIntermediateAuxiliaryData();
    var mockDirectedStateGraph = MockDirectedStateGraph();
    var mockIntermediateState = MockIntermediateState();
    var mockIntermediateVariation = MockIntermediateVariation();
    var mockTree = MockTree();

    setUp(() async {
      /// Nodes set up
      // 1
      when(node.name).thenReturn('someElement/blue');
      when(node.generator).thenReturn(mockPBGenerator);
      when(node.auxiliaryData).thenReturn(mockIntermediateAuxiliaryData);
      when(node.managerData).thenReturn(mockPBGenerationViewData);
      when(node.currentContext).thenReturn(mockContext);
      // 2
      when(node2.name).thenReturn('someElement/green');
      when(node2.generator).thenReturn(mockPBGenerator);
      when(node2.currentContext).thenReturn(mockContext);

      /// IntermediateAuxiliaryData
      when(mockIntermediateAuxiliaryData.stateGraph)
          .thenReturn(mockDirectedStateGraph);

      /// DirectedStateGraph
      when(mockDirectedStateGraph.states).thenReturn([mockIntermediateState]);

      /// IntermediateState
      when(mockIntermediateState.variation)
          .thenReturn(mockIntermediateVariation);

      /// IntermediateVariation
      when(mockIntermediateVariation.node).thenReturn(node2);

      /// PBGenerator
      when(mockPBGenerator.generate(any, any)).thenReturn('code');

      /// Context
      when(mockContext.project).thenReturn(mockProject);
      when(mockContext.treeRoot).thenReturn(mockTree);

      /// Project
      when(mockProject.genProjectData).thenReturn(mockPBGenerationProjectData);
      when(mockProject.forest).thenReturn([]);
      when(mockProject.fileStructureStrategy)
          .thenReturn(providerFileStructureStrategy);

      /// PBGenerationManager
      when(mockPBGenerationManager.generate(any)).thenReturn('code');

      /// PBGenerationProjectData
      when(mockPBGenerationProjectData.addDependencies('', '')).thenReturn('');
    });

    test('Provider Strategy Test', () async {
      await providerFileStructureStrategy.setUpDirectories();
      var tempNode = await providerMiddleware.applyMiddleware(node);
      expect(tempNode is PBIntermediateNode, true);
      expect(await File('${testingPath}lib/models/some_element.dart').exists(),
          true);
    });

    tearDownAll(() {
      Process.runSync('rm', ['-rf', '${testingPath}lib']);
    });
  });
}
