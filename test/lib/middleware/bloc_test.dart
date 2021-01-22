import 'dart:io';

import 'package:mockito/mockito.dart';
import 'package:parabeac_core/generation/generators/middleware/state_management/bloc_middleware.dart';
import 'package:parabeac_core/generation/generators/pb_generation_manager.dart';
import 'package:parabeac_core/generation/generators/pb_generator.dart';
import 'package:parabeac_core/generation/generators/util/pb_generation_project_data.dart';
import 'package:parabeac_core/generation/generators/util/pb_generation_view_data.dart';
import 'package:parabeac_core/generation/generators/value_objects/file_structure_strategy.dart/flutter_file_structure_strategy.dart';
import 'package:parabeac_core/generation/generators/writers/pb_flutter_writer.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_context.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_project.dart';
import 'package:test/test.dart';

class MockPBGenerationManager extends Mock implements PBGenerationManager {}

class MockPBIntermediateNode extends Mock implements PBIntermediateNode {}

class MockContext extends Mock implements PBContext {}

class MockProject extends Mock implements PBProject {}

class MockPBGenerationProjectData extends Mock
    implements PBGenerationProjectData {}

class MockPBGenerationViewData extends Mock implements PBGenerationViewData {}

class MockPBGenerator extends Mock implements PBGenerator {}

// class MockFileStructureStrategy extends Mock
//     implements FlutterFileStructureStrategy {}

void main() {
  group('BLoC Strategy Test', () {
    MockPBGenerationManager mockPBGenerationManager;

    BLoCMiddleware bLoCMiddleware;

    MockPBIntermediateNode node;

    MockContext mockContext;

    MockProject mockProject;

    MockPBGenerationProjectData mockPBGenerationProjectData;

    MockPBGenerationViewData mockPBGenerationViewData;

    MockPBGenerator mockPBGenerator;

    FlutterFileStructureStrategy mockFileStructureStrategy;

    setUp(() async {
      mockPBGenerationManager = MockPBGenerationManager();
      node = MockPBIntermediateNode();
      mockContext = MockContext();
      mockProject = MockProject();
      mockPBGenerationProjectData = MockPBGenerationProjectData();
      bLoCMiddleware = BLoCMiddleware(mockPBGenerationManager);
      mockPBGenerationViewData = MockPBGenerationViewData();
      mockPBGenerator = MockPBGenerator();
      mockFileStructureStrategy = FlutterFileStructureStrategy(
        '${Directory.current.path}/test/lib/middleware/',
        PBFlutterWriter(),
        mockProject,
      );

      when(node.name).thenReturn('someEle/blue');

      when(node.generator).thenReturn(mockPBGenerator);

      when(node.managerData).thenReturn(mockPBGenerationViewData);

      when(node.currentContext).thenReturn(mockContext);

      when(mockContext.project).thenReturn(mockProject);

      when(mockProject.genProjectData).thenReturn(mockPBGenerationProjectData);

      when(mockProject.forest).thenReturn([]);

      // when(mockFileStructureStrategy.pageWriter).thenReturn(PBFlutterWriter());

      // when(mockFileStructureStrategy.screenDirectoryPath)
      //     .thenReturn('${Directory.current.path}/test/lib/middleware/');

      // when(mockFileStructureStrategy.viewDirectoryPath)
      //     .thenReturn('${Directory.current.path}/test/lib/middleware/');

      // when(mockFileStructureStrategy.isSetUp).thenReturn(false);

      when(mockProject.fileStructureStrategy)
          .thenReturn(mockFileStructureStrategy);

      when(mockPBGenerationManager.generate(node)).thenReturn('code');

      when(mockPBGenerationProjectData.addDependencies('', '')).thenReturn('');
    });

    test('', () async {
      await mockFileStructureStrategy.setUpDirectories();
      var tempNode = await bLoCMiddleware.applyMiddleware(node);
      expect(tempNode is PBIntermediateNode, true);
    });
  });
}
