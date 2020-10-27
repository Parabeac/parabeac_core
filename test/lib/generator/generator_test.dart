import 'package:parabeac_core/generation/generators/pb_flutter_generator.dart';
import 'package:parabeac_core/generation/generators/visual-widgets/pb_container_gen.dart';
import 'package:parabeac_core/generation/generators/visual-widgets/pb_text_gen.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/inherited_container.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/inherited_text.dart';
import 'package:parabeac_core/interpret_and_optimize/value_objects/point.dart';
import 'package:test/test.dart';
import 'package:mockito/mockito.dart';

class MockInheritedContainer extends Mock implements InheritedContainer {}

class MockInheritedText extends Mock implements InheritedText {}

class MockManager extends Mock implements PBFlutterGenerator {}

void main() {
  group('GGenerator test', () {
    var mockManager, mockGenerator, mockTextGenerator;
    var mockInheritedContainer, mockInheritedText;
    setUp(() {
      mockInheritedContainer = MockInheritedContainer();
      mockInheritedText = MockInheritedText();

      when(mockInheritedContainer.child).thenReturn(mockInheritedText);

      when(mockInheritedContainer.topLeftCorner).thenReturn(Point(0, 0));

      when(mockInheritedContainer.bottomRightCorner)
          .thenReturn(Point(100, 100));

      when(mockInheritedText.name).thenReturn('Test Name');

      mockTextGenerator = PBTextGen();

      when(mockInheritedText.generator).thenReturn(mockTextGenerator);

      when(mockInheritedText.isTextParameter).thenReturn(false);

      when(mockInheritedText.text).thenReturn('Test Text');

      mockManager = PBFlutterGenerator(null);
      mockGenerator = PBContainerGenerator();

      mockGenerator.manager = mockManager;
    });

    test('', () {
      var result = mockGenerator.generate(mockInheritedContainer);

      expect(result != null, true);
      expect(result is String, true);

      // Do not modify
      expect(result, '''Container(child: Text(
'Test Text',
style: TextStyle(
),
))''');

      // Print statement to check the result visually
      // print(result);
    });
  });
}
