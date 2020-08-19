import 'package:mockito/mockito.dart';
import 'package:parabeac_core/input/entities/layers/abstract_group_layer.dart';
import 'package:parabeac_core/input/entities/layers/abstract_layer.dart';
import 'package:parabeac_core/input/entities/layers/artboard.dart';
import 'package:parabeac_core/input/entities/layers/group.dart';
import 'package:parabeac_core/input/entities/layers/rectangle.dart';
import 'package:parabeac_core/input/entities/objects/frame.dart';
import 'package:parabeac_core/input/services/positional_cleansing_service.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/layouts/temp_group_layout_node.dart';
import 'package:test/test.dart';

class WeatherAPI extends Mock implements TempGroupLayoutNode {}

class GroupMock extends Mock implements Group {}

class ArtboardMock extends Mock implements Artboard {}

class RectangleMock extends Mock implements Rectangle {}

void main() {
  group('Eliminating Offset Test', () {
    var groupSketchNode, artboard, rec;
    var parentFrame, childFrame;
    PositionalCleansingService service;
    setUp(() {
      service = PositionalCleansingService();

      ///TLC: (100, 100) BRC: (300, 300)
      parentFrame = Frame(x: 100, y: 100, width: 200, height: 200);

      ///TLC: (0, 0) BRC: (100, 100)
      childFrame = Frame(x: 0, y: 0, width: 100, height: 100);

      rec = RectangleMock();
      when(rec.frame).thenReturn(childFrame);
      var children = <SketchNode>[rec];

      groupSketchNode = GroupMock();
      when(groupSketchNode.layers).thenReturn(children);
      when(groupSketchNode.frame).thenReturn(parentFrame);

      artboard = ArtboardMock();
      when(artboard.layers).thenReturn(children);
      when(artboard.frame).thenReturn(parentFrame);
    });
    test('Eliminating Artboard Offset Test', () {
      var artboardResult = service.eliminateOffset(artboard);
      var recResult = (artboardResult as AbstractGroupLayer).layers[0];
      var frameR = recResult.frame;
      expect(frameR.x, 100);
      expect(frameR.y, 100);
    });

    test('Eliminating Group Offset Test', () {
      var groupResult = service.eliminateOffset(groupSketchNode);
      var recResult = (groupResult as AbstractGroupLayer).layers[0];
      var frameR = recResult.frame;
      expect(frameR.x, 100);
      expect(frameR.y, 100);
    });
  });
}
