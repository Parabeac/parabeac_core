import 'package:mockito/mockito.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/alignments/injected_positioned.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/injected_container.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/layouts/stack.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_configuration.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_context.dart';
import 'package:parabeac_core/interpret_and_optimize/value_objects/point.dart';
import 'package:test/test.dart';
import 'package:uuid/uuid.dart';

class MockContext extends Mock implements PBContext {
  @override
  PBConfiguration configuration;

  @override
  Map jsonConfigurations;

  @override
  Point screenBottomRightCorner;

  @override
  Point screenTopLeftCorner;
}

class MockContainer extends Mock implements InjectedContainer {}

void main() {
  group('Testing the Positions generated for stacks', () {
    PBIntermediateStackLayout stack;
    setUp(() {
      stack = PBIntermediateStackLayout('Testing Stack', Uuid().v4(),
          currentContext: MockContext());
    });

    test('Testing the stack alignment algorithm', () {
      var isYPositive = true, isXPositive = true;

      stack.topLeftCorner = Point(-200, -200);
      stack.bottomRightCorner = Point(200, 200);
      var startingTLC = Point(100, 100), startingBTC = Point(150, 150);

      var containers = List.generate(4, (index) {
        var mockContainer = MockContainer();
        when(mockContainer.topLeftCorner).thenReturn(Point(
            isXPositive ? startingTLC.x : (startingTLC.x * -1),
            (isYPositive ? startingTLC.y : startingTLC.y * -1)));
        when(mockContainer.bottomRightCorner).thenReturn(Point(
            isXPositive ? startingBTC.x : (startingBTC.x * -1),
            (isYPositive ? startingBTC.y : startingBTC.y * -1)));
        index % 2 == 0
            ? isYPositive = !isYPositive
            : isXPositive = !isXPositive;
        return mockContainer;
      }).cast<PBIntermediateNode>();

      stack.replaceChildren(containers);
      stack.alignChildren();
      containers = stack.children;
      expect(containers.length, 4, reason: 'numbers of children change');

      isXPositive = true;
      isYPositive = true;
      for (var i = 0; i < containers.length; i++) {
        var container = containers[i];
        expect(container.runtimeType, InjectedPositioned,
            reason: 'should be of type InjectedPositioned');

        i % 2 == 0 ? isYPositive = !isYPositive : isXPositive = !isXPositive;

        //TODO: test the relative position
      }
    });
  });
}
