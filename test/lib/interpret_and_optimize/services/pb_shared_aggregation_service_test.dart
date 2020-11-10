import 'package:mockito/mockito.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/pb_shared_master_node.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/layouts/temp_group_layout_node.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/pb_shared_instance.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_symbol_storage.dart';
import 'package:parabeac_core/interpret_and_optimize/services/pb_shared_aggregation_service.dart';
import 'package:test/test.dart';

class PBSharedMasterNodeMock extends Mock implements PBSharedMasterNode {}

class PBTempGroupNodeMock extends Mock implements TempGroupLayoutNode {}

class PBSharedInstanceIntermediateNodeMock extends Mock
    implements PBSharedInstanceIntermediateNode {
  @override
  String get UUID => 'INSTANCE0_UUID';
}

void main() {
  group('', () {
    final MASTER0_UUID = 'MASTER0_UUID',
        MASTER1_UUID = 'MASTER1_UUID',
        INSTANCE0_UUID = 'INSTANCE0_UUID';
    PBSharedInterAggregationService pbSharedInterAggregationService;
    PBSharedInstanceIntermediateNode instanceNode0;
    PBSharedMasterNode masterNode0, masterNode1;
    List<PBSharedParameterProp> masterParameters;
    List<PBSharedParameterValue> instaceValues;
    TempGroupLayoutNode rootNode;

    setUp(() {
      pbSharedInterAggregationService = PBSharedInterAggregationService();

      instanceNode0 = PBSharedInstanceIntermediateNodeMock();
      rootNode = PBTempGroupNodeMock();
      instanceNode0 = PBSharedInstanceIntermediateNodeMock();

      masterNode0 = PBSharedMasterNodeMock();
      when(masterNode0.UUID).thenReturn(MASTER0_UUID);

      masterNode1 = PBSharedMasterNodeMock();
      when(masterNode1.UUID).thenReturn(MASTER1_UUID);

      var parameterAlternator = false;
      masterParameters = [];
      instaceValues = [];

      for (var i = 0; i < 2; i++) {
        var masterParameter = PBSharedParameterProp(
          'masterParam',
          parameterAlternator ? String : PBSharedInstanceIntermediateNode,
          parameterAlternator ? null : instanceNode0,
          true,
          parameterAlternator ? 'test0' : 'test1',
          parameterAlternator ? 'uuid0' : INSTANCE0_UUID,
          null,
        );
        var instaceParameter = PBSharedParameterValue(
          parameterAlternator ? String : PBSharedInstanceIntermediateNode,
          parameterAlternator ? 'test' : instanceNode0,
          null,
          'instanceParam',
        );

        instaceValues.add(instaceParameter);
        masterParameters.add(masterParameter);
        parameterAlternator = !parameterAlternator;
      }

      when(masterNode0.overridableProperties).thenReturn(masterParameters);
      when(masterNode1.overridableProperties).thenReturn(masterParameters);

      when(rootNode.children).thenReturn([instanceNode0]);
      when(masterNode0.child).thenReturn(rootNode);
      when(instanceNode0.sharedParamValues).thenReturn(instaceValues);
    });

    test(
        '''Testing that PBSharedInstanceIntermediateNode got its attributes from a
    PBSharedMasterNode that has not been processed yet. Once the symbol storage processes the
    PBSharedMasterNode the instance node should get its attributes populated from its master
    ''', () async {
      var name = 'test_name';
      var symbolStorage = PBSymbolStorage();

      ///Linking the [instanceNode0] and [masterNode1].
      when(instanceNode0.SYMBOL_ID).thenReturn(MASTER1_UUID);
      when(masterNode1.SYMBOL_ID).thenReturn(MASTER1_UUID);
      when(masterNode0.SYMBOL_ID).thenReturn(MASTER0_UUID);

      pbSharedInterAggregationService.gatherSharedParameters(
          masterNode0, masterNode0.child);
      expect(masterNode0.overridableProperties[0].type,
          PBSharedInstanceIntermediateNode);
      expect(
          (masterNode0.overridableProperties[0].value
                  as PBSharedInstanceIntermediateNode)
              .functionCallName,
          null);
    });
  });
}
