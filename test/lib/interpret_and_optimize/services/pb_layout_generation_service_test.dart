import 'package:mockito/mockito.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_configuration.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_context.dart';
import 'package:parabeac_core/interpret_and_optimize/value_objects/point.dart';
import 'package:parabeac_core/interpret_and_optimize/services/pb_layout_generation_service.dart';
import 'package:test/test.dart';
import 'package:parabeac_core/input/sketch/entities/objects/frame.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/layouts/temp_group_layout_node.dart';
import 'package:parabeac_core/input/sketch/entities/layers/group.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/injected_container.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/layouts/column.dart';
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
  var jsonConfigurations = {
    'default': {
      'widgetStyle': 'Material',
      'widgetType': 'Stateless',
      'widgetSpacing': 'Expanded'
    },
    'This will be replaced by a Object ID to determine specific configurations for each page':
        {
      'widgetStyle': 'Material',
      'widgetType': 'Stateless',
      'widgetSpacing': 'Expanded'
    },
    'root': 'AC2E7423-4609-4F37-8BCA-7E915944FFE2'
  };
  TempGroupLayoutNode root;

  /// Test-driven development.
  group('Test that children of layouts create the proper sizing.', () {
    ///Test for inside of a artboard.
    setUp(() async {
      var context = PBContext(jsonConfigurations: jsonConfigurations);
      context.screenTopLeftCorner = Point(0, 0);
      context.screenBottomRightCorner = Point(414, 896);
      var gm = Group();
      gm.frame = Frame(x: 0, y: 46, width: 414, height: 850);
      root = await gm.interpretNode(context);

      var gm2 = Group();
      gm2.frame = Frame(x: 0, y: 86, width: 414, height: 100);
      var row = await gm2.interpretNode(context);
      root.addChild(row);

      row.addChild(InjectedContainer(Point(100, 186), Point(0, 86), Uuid().v4(),
          currentContext: context));
      row.addChild(InjectedContainer(
          Point(250, 186), Point(150, 86), Uuid().v4(),
          currentContext: context));

      root.addChild(InjectedContainer(Point(50, 50), Point(0, 0), Uuid().v4(),
          currentContext: context));

      var result =
          PBLayoutGenerationService(currentContext: context).injectNodes(root);
      expect(result.child.runtimeType, PBIntermediateColumnLayout);
      expect(0, result.topLeftCorner.x);
      expect(0, result.topLeftCorner.y);
      expect(250, result.bottomRightCorner.x);
      expect(186, result.bottomRightCorner.y);
    });
  });
}
