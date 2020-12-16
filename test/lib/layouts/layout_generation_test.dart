import 'package:mockito/mockito.dart';
import 'package:parabeac_core/controllers/main_info.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/layouts/column.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/layouts/temp_group_layout_node.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_layout_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_context.dart';
import 'package:parabeac_core/interpret_and_optimize/services/pb_layout_generation_service.dart';
import 'package:parabeac_core/interpret_and_optimize/value_objects/point.dart';
import 'package:test/test.dart';

class TempGroupMock extends Mock implements TempGroupLayoutNode {}

class PBIntermediateNodeMock extends Mock implements PBIntermediateNode {}

void main() {
  group('Testing the correct generation of the children in the layout service',
      () {
    PBIntermediateNodeMock leftItem;
    PBIntermediateNodeMock rightItem;

    TempGroupMock tempGroup;
    MainInfo().configurationType = 'default';
    PBContext currentContext = PBContext(jsonConfigurations: {
      "default": {
        "widgetStyle": "Material",
        "widgetType": "Stateless",
        "widgetSpacing": "Expanded",
        "layoutPrecedence": ["column", "row", "stack"]
      },
      "stack": {
        "widgetStyle": "Material",
        "widgetType": "Stateless",
        "widgetSpacing": "Expanded",
        "layoutPrecedence": ["stack"]
      },
      "This will be replaced by a Object ID to determine specific configurations for each page":
          {
        "widgetStyle": "Material",
        "widgetType": "Stateless",
        "widgetSpacing": "Expanded"
      },
      "root": "AC2E7423-4609-4F37-8BCA-7E915944FFE2"
    });

    setUp(() {
      leftItem = PBIntermediateNodeMock();
      rightItem = PBIntermediateNodeMock();

      tempGroup = TempGroupMock();

      when(leftItem.topLeftCorner).thenReturn(Point(0, 0));
      when(leftItem.bottomRightCorner).thenReturn(Point(100, 100));
      when(leftItem.UUID).thenReturn('UUIDleftItem');
      when(leftItem.name).thenReturn('leftItem');

      when(rightItem.topLeftCorner).thenReturn(Point(0, 150));
      when(rightItem.bottomRightCorner).thenReturn(Point(200, 250));
      when(rightItem.UUID).thenReturn('UUIDrightItem');
      when(rightItem.name).thenReturn('rightItem');

      when(tempGroup.name).thenReturn('testTempGroup');
      when(tempGroup.currentContext).thenReturn(currentContext);
      when(tempGroup.originalRef).thenReturn({});
      when(tempGroup.children).thenReturn([
        leftItem,
        rightItem,
      ]);
    });

    test('', () {
      var result = PBLayoutGenerationService(currentContext: currentContext)
          .extractLayouts(tempGroup);
      expect(result.runtimeType, PBIntermediateColumnLayout);
      if (result is PBLayoutIntermediateNode) {
        expect(result.children != null && result.children.isNotEmpty, true);
        expect(result.children[0].topLeftCorner, Point(0, 0));
        expect(result.children[0].bottomRightCorner, Point(100, 100));
        expect(result.children[1].topLeftCorner, Point(0, 150));
        expect(result.children[1].bottomRightCorner, Point(200, 250));
      }
    });
  });
}
