import 'package:mockito/mockito.dart';
import 'package:parabeac_core/generation/generators/middleware/state_management/provider_middleware.dart';
import 'package:parabeac_core/generation/generators/pb_generation_manager.dart';
import 'package:parabeac_core/generation/generators/pb_generator.dart';
import 'package:parabeac_core/generation/generators/util/pb_generation_project_data.dart';
import 'package:parabeac_core/generation/generators/util/pb_generation_view_data.dart';
import 'package:parabeac_core/generation/generators/value_objects/file_structure_strategy/provider_file_structure_strategy.dart';
import 'package:parabeac_core/generation/generators/value_objects/generation_configuration/provider_generation_configuration.dart';
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

class MockConfig extends Mock implements ProviderGenerationConfiguration {}

class MockFileStrategy extends Mock implements ProviderFileStructureStrategy {}

void main() {
  final modelPath = 'lib/models/';
  final viewPath = 'lib/widgets';
  group('Middlewares Tests', () {
    var mockConfig = MockConfig();
    var mockPBGenerationManager = MockPBGenerationManager();
    var providerMiddleware =
        ProviderMiddleware(mockPBGenerationManager, mockConfig);
    var node = MockPBIntermediateNode();
    var node2 = MockPBIntermediateNode();
    var mockContext = MockContext();
    var mockProject = MockProject();
    var mockPBGenerationProjectData = MockPBGenerationProjectData();
    var mockPBGenerationViewData = MockPBGenerationViewData();
    var mockPBGenerator = MockPBGenerator();
    var providerFileStructureStrategy = MockFileStrategy();

    var mockIntermediateAuxiliaryData = MockIntermediateAuxiliaryData();
    var mockDirectedStateGraph = MockDirectedStateGraph();
    var mockIntermediateState = MockIntermediateState();
    var mockIntermediateVariation = MockIntermediateVariation();
    var tree = PBIntermediateTree();

    setUp(() async {
      /// Nodes set up
      // 1
      when(node.name).thenReturn('someElement/blue');
      when(node.generator).thenReturn(mockPBGenerator);
      when(node.auxiliaryData).thenReturn(mockIntermediateAuxiliaryData);

      // 2
      when(node2.name).thenReturn('someElement/green');
      when(node2.generator).thenReturn(mockPBGenerator);

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
      when(mockContext.tree).thenReturn(tree);
      when(mockContext.managerData).thenReturn(mockPBGenerationViewData);

      // Tree
      tree.rootNode = node;
      tree.context = mockContext;

      /// Project
      when(mockProject.genProjectData).thenReturn(mockPBGenerationProjectData);
      when(mockProject.forest).thenReturn([]);

      // Configuration
      when(mockConfig.fileStructureStrategy)
          .thenReturn(providerFileStructureStrategy);
      when(mockConfig.registeredModels).thenReturn({});

      /// PBGenerationManager
      when(mockPBGenerationManager.generate(any, mockContext))
          .thenReturn('code');

      /// PBGenerationProjectData
      when(mockPBGenerationProjectData.addDependencies('', '')).thenReturn('');

      // FileStructureStrategy
      when(providerFileStructureStrategy.RELATIVE_MODEL_PATH)
          .thenReturn(modelPath);
    });

    test('Provider Strategy Test', () async {
      await providerFileStructureStrategy.setUpDirectories();
      var tempNode =
          await providerMiddleware.applyMiddleware(tree, mockContext);
      expect(tempNode, <PBIntermediateTree>[]);
    });
  });
}
