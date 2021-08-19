import 'dart:math';
import 'package:parabeac_core/generation/flutter_project_builder/import_helper.dart';
import 'package:parabeac_core/generation/generators/pb_flutter_generator.dart';
import 'package:parabeac_core/generation/generators/util/pb_generation_project_data.dart';
import 'package:parabeac_core/generation/generators/util/pb_generation_view_data.dart';
import 'package:parabeac_core/generation/generators/visual-widgets/pb_container_gen.dart';
import 'package:parabeac_core/generation/generators/visual-widgets/pb_text_gen.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/inherited_container.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/inherited_text.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_context.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_intermediate_node_tree.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_project.dart';
import 'package:parabeac_core/interpret_and_optimize/state_management/intermediate_auxillary_data.dart';
import 'package:test/test.dart';
import 'package:mockito/mockito.dart';

class MockInheritedContainer extends Mock implements InheritedContainer {}

class MockInheritedText extends Mock implements InheritedText {}

class MockManager extends Mock implements PBFlutterGenerator {}

class MockContext extends Mock implements PBContext {}

class MockData extends Mock implements IntermediateAuxiliaryData {}

class MockPBContext extends Mock implements PBContext {}

class MockProject extends Mock implements PBProject {}

class MockGenProjectData extends Mock implements PBGenerationProjectData {}

class MockPBGenViewData extends Mock implements PBGenerationViewData {}

class MockPBITree extends Mock implements PBIntermediateTree {}

class MockFrame extends Mock implements Rectangle {}

void main() {
  group('Generator test', () {
    var mockManager, mockGenerator, mockTextGenerator;
    var mockInheritedContainer, mockInheritedText;
    var mockContext, mockData;
    var mockPBContext;
    var mockProject;
    var mockGenProjectData;
    var mockGenViewData;
    var mockTree;
    var mockFrame;
    setUp(() {
      mockInheritedContainer = MockInheritedContainer();
      mockInheritedText = MockInheritedText();
      mockContext = MockContext();
      mockData = MockData();
      mockPBContext = MockPBContext();
      mockProject = MockProject();
      mockGenProjectData = MockGenProjectData();
      mockGenViewData = MockPBGenViewData();
      mockTree = MockPBITree();
      mockFrame = MockFrame();
      mockManager = PBFlutterGenerator(ImportHelper());
      mockGenerator = PBContainerGenerator();

      when(mockContext.tree).thenReturn(mockTree);

      when(mockContext.project).thenReturn(mockProject);

      when(mockContext.managerData).thenReturn(mockGenViewData);

      when(mockTree.childrenOf(mockInheritedContainer))
          .thenReturn(<PBIntermediateNode>[mockInheritedText]);

      when((mockInheritedContainer as MockInheritedContainer).auxiliaryData)
          .thenReturn(mockData);

      when((mockPBContext as MockPBContext).project).thenReturn(mockProject);

      when((mockProject as MockProject).genProjectData)
          .thenReturn(mockGenProjectData);

      when(mockInheritedContainer.topLeftCorner).thenReturn(Point(0, 0));

      when(mockInheritedContainer.bottomRightCorner)
          .thenReturn(Point(100, 100));

      when(mockInheritedContainer.frame).thenReturn(mockFrame);

      when(mockFrame.height).thenReturn(100.0);

      when(mockFrame.width).thenReturn(100.0);

      when(mockInheritedText.name).thenReturn('Test Name');
      when(mockInheritedText.auxiliaryData).thenReturn(mockData);

      mockTextGenerator = PBTextGen();

      when(mockInheritedText.generator).thenReturn(mockTextGenerator);

      when(mockInheritedText.isTextParameter).thenReturn(false);

      when(mockInheritedText.text).thenReturn('Test Text');
    });

    test('', () {
      var result = (mockGenerator as PBContainerGenerator)
          .generate(mockInheritedContainer, mockContext);

      expect(result != null, true);
      expect(result is String, true);

      // Do not modify
      expect(result,
          '''Container(width: 100.000,height: 100.000,child: AutoSizeText(
'Test Text',
style: TextStyle(
),
))''');

      // Print statement to check the result visually
      // print(result);
    });
  });
}
