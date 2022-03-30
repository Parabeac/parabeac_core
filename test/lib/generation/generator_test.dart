@Skip('Fix generator not taking context')

import 'dart:math';
import 'package:parabeac_core/generation/flutter_project_builder/import_helper.dart';
import 'package:parabeac_core/generation/generators/pb_flutter_generator.dart';
import 'package:parabeac_core/generation/generators/util/pb_generation_project_data.dart';
import 'package:parabeac_core/generation/generators/util/pb_generation_view_data.dart';
import 'package:parabeac_core/generation/generators/visual-widgets/pb_container_gen.dart';
import 'package:parabeac_core/generation/generators/visual-widgets/pb_text_gen.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/inherited_container.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/inherited_text.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_context.dart';
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

void main() {
  group('Generator test', () {
    var mockManager, mockGenerator, mockTextGenerator;
    var mockInheritedContainer, mockInheritedText;
    var mockContext, mockData;
    var mockPBContext;
    var mockProject;
    var mockGenProjectData;
    var mockGenViewData;
    setUp(() {
      mockInheritedContainer = MockInheritedContainer();
      mockInheritedText = MockInheritedText();
      mockContext = MockContext();
      mockData = MockData();
      mockPBContext = MockPBContext();
      mockProject = MockProject();
      mockGenProjectData = MockGenProjectData();
      mockGenViewData = MockPBGenViewData();

      when(mockInheritedContainer.child).thenReturn(mockInheritedText);

      when((mockInheritedContainer as MockInheritedContainer).auxiliaryData)
          .thenReturn(mockData);

      when((mockInheritedText as MockInheritedText).currentContext)
          .thenReturn(mockPBContext);

      when((mockPBContext as MockPBContext).project).thenReturn(mockProject);

      when((mockProject as MockProject).genProjectData)
          .thenReturn(mockGenProjectData);

      when((mockInheritedText as MockInheritedText).managerData)
          .thenReturn(mockGenViewData);

      when(mockInheritedContainer.topLeftCorner).thenReturn(Point(0, 0));

      when(mockInheritedContainer.bottomRightCorner)
          .thenReturn(Point(100, 100));

      when(mockInheritedText.name).thenReturn('Test Name');
      when(mockInheritedText.auxiliaryData).thenReturn(mockData);

      mockTextGenerator = PBTextGen();

      when(mockInheritedText.generator).thenReturn(mockTextGenerator);

      when(mockInheritedText.isTextParameter).thenReturn(false);

      when(mockInheritedText.text).thenReturn('Test Text');

      mockManager = PBFlutterGenerator(ImportHelper());
      mockGenerator = PBContainerGenerator();
    });

    test('', () {
      var result = (mockGenerator as PBContainerGenerator)
          .generate(mockInheritedContainer, mockContext);

      expect(result != null, true);
      expect(result is String, true);

      // Do not modify
      expect(result, '''Container(child: AutoSizeText(
'Test Text',
style: TextStyle(
),
))''');

      // Print statement to check the result visually
      // print(result);
    });
  });
}
