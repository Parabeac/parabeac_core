import 'package:parabeac_core/generation/prototyping/pb_dest_holder.dart';
import 'package:parabeac_core/generation/prototyping/pb_prototype_linker_service.dart';
import 'package:parabeac_core/generation/prototyping/pb_prototype_node.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/injected_container.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_context.dart';
import 'package:parabeac_core/interpret_and_optimize/value_objects/point.dart';
import 'package:test/test.dart';
import 'package:mockito/mockito.dart';

class MockContainer extends Mock implements InjectedContainer {}

class MockPrototypeNode extends Mock implements PrototypeNode {}

class ContextMock extends Mock implements PBContext {}

void main() {
  group('Prototype linker test', () {
    PBPrototypeLinkerService _pbPrototypeLinkerService;
    InjectedContainer mockNode, mockNode2;
    MockPrototypeNode prototypeNode;
    var currentContext;
    setUp(() {
      currentContext = ContextMock();
      when(currentContext.screenTopLeftCorner).thenReturn(Point(215, -295));
      when(currentContext.screenBottomRightCorner).thenReturn(Point(590, 955));

      _pbPrototypeLinkerService = PBPrototypeLinkerService();
      mockNode = InjectedContainer(
          Point(1000, 1000), Point(100, 100), 'testName', '00530055',
          currentContext: currentContext);
      mockNode2 = InjectedContainer(
          Point(1000, 1000), Point(100, 100), 'testName2', '00530055',
          currentContext: currentContext);
      prototypeNode = MockPrototypeNode();

      when(prototypeNode.destinationName).thenReturn('mockPage');
      when(prototypeNode.destinationUUID).thenReturn('00530055');

      mockNode.prototypeNode = prototypeNode;

      mockNode.addChild(mockNode2);
    });
    test('', () async {
      var result = await _pbPrototypeLinkerService.linkPrototypeNodes(mockNode);

      /// If the child of the result is `PBDestHolder` that means
      /// that the replace was done corretly
      expect(result.child is PBDestHolder, true);
    });
  });
}
