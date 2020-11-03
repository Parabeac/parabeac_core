import 'package:parabeac_core/controllers/main_info.dart';
import 'package:parabeac_core/input/sketch/entities/layers/symbol_instance.dart';
import 'package:parabeac_core/input/sketch/entities/layers/symbol_master.dart';
import 'package:parabeac_core/input/sketch/entities/objects/frame.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/pb_shared_instance.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/pb_shared_master_node.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_context.dart';
import 'package:parabeac_core/interpret_and_optimize/services/pb_symbol_linker_service.dart';
import 'package:parabeac_core/interpret_and_optimize/value_objects/point.dart';
import 'package:test/test.dart';
import 'package:mockito/mockito.dart';

class MockReference extends Mock implements SymbolMaster {}

class SecondReference extends Mock implements SymbolInstance {}

void main() {
  group('Symbol link test', () {
    PBSymbolLinkerService pbSymbolLinkerService;
    PBSharedMasterNode masterNode;
    PBSharedInstanceIntermediateNode instanceNode;
    MockReference mockReference;
    SecondReference secondReference;
    setUp(() {
      MainInfo().configurationType = 'default';
      mockReference = MockReference();
      pbSymbolLinkerService = PBSymbolLinkerService();
      secondReference = SecondReference();

      when(mockReference.UUID).thenReturn('010101');
      when(mockReference.boundaryRectangle).thenReturn(Frame(
        x: 100,
        y: 100,
        width: 200,
        height: 200,
      ));
      when(secondReference.UUID).thenReturn('101010');
      when(secondReference.boundaryRectangle).thenReturn(Frame(
        x: 100,
        y: 100,
        width: 200,
        height: 200,
      ));

      masterNode = PBSharedMasterNode(
        mockReference,
        '02353',
        'masterTest',
        Point(0, 0),
        Point(0, 0),
        overridableProperties: [],
        currentContext: PBContext(jsonConfigurations: {
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
        }),
      );
      instanceNode = PBSharedInstanceIntermediateNode(
        secondReference,
        '02353',
        sharedParamValues: [],
      );
    });
    test('', () async {
      await pbSymbolLinkerService.linkSymbols(masterNode);
      PBSharedInstanceIntermediateNode result =
          await pbSymbolLinkerService.linkSymbols(instanceNode);

      expect(result != null, true);
      expect(result.functionCallName, masterNode.name);
    });
  });
}
