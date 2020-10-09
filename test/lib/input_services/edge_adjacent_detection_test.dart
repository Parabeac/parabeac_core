import 'package:mockito/mockito.dart';
import 'package:parabeac_core/generation/generators/visual-widgets/pb_bitmap_gen.dart';
import 'package:parabeac_core/generation/generators/visual-widgets/pb_container_gen.dart';
import 'package:parabeac_core/input/sketch/entities/layers/abstract_layer.dart';
import 'package:parabeac_core/input/sketch/entities/objects/frame.dart';
import 'package:parabeac_core/input/sketch/entities/style/border.dart';
import 'package:parabeac_core/input/sketch/entities/style/color.dart';
import 'package:parabeac_core/input/sketch/entities/style/style.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/inherited_shape_path.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_context.dart';
import 'package:parabeac_core/input/sketch/entities/layers/shape_path.dart';
import 'package:test/test.dart';

class SketchNodeMock extends Mock implements SketchNode {}

class ContextMock extends Mock implements PBContext {}

class ShapePathMock extends Mock implements ShapePath {}

void main() {
  group('Test for detecting a vertical line', () {
    ShapePathMock sketchNode;
    ContextMock context;
    InheritedShapePath shapePath;

    setUp(() {
      sketchNode = ShapePathMock();
      context = ContextMock();

      when(sketchNode.points).thenReturn([
        {
          'point': '{0,0}',
        },
        {
          'point': '{0,50}',
        },
      ]);

      when(sketchNode.boundaryRectangle)
          .thenReturn(Frame(x: 0, y: 0, width: 2, height: 50));

      when(sketchNode.style).thenReturn(Style(
        borders: [
          Border(
            color: Color(
              alpha: 1,
              red: 1,
              green: 1,
              blue: 1,
            ),
          ),
        ],
      ));

      when(sketchNode.do_objectID).thenReturn('');
      shapePath = InheritedShapePath(sketchNode, currentContext: context);
    });

    test('Detecting line', () {
      expect(shapePath.generator.runtimeType, PBContainerGenerator);
    });
  });

  group('Test for detecting a horizontal line', () {
    ShapePathMock sketchNode;
    ContextMock context;
    InheritedShapePath shapePath;

    setUp(() {
      sketchNode = ShapePathMock();
      context = ContextMock();

      when(sketchNode.points).thenReturn([
        {
          'point': '{0,0}',
        },
        {
          'point': '{50,0}',
        },
      ]);

      when(sketchNode.boundaryRectangle)
          .thenReturn(Frame(x: 0, y: 0, width: 50, height: 2));

      when(sketchNode.style).thenReturn(Style(
        borders: [
          Border(
            color: Color(
              alpha: 1,
              red: 1,
              green: 1,
              blue: 1,
            ),
          ),
        ],
      ));

      when(sketchNode.do_objectID).thenReturn('');
      shapePath = InheritedShapePath(sketchNode, currentContext: context);
    });

    test('Detecting line', () {
      expect(shapePath.generator.runtimeType, PBContainerGenerator);
    });
  });

  group('Test for detecting a ShapePath', () {
    ShapePathMock sketchNode;
    ContextMock context;
    InheritedShapePath shapePath;

    setUp(() {
      sketchNode = ShapePathMock();
      context = ContextMock();

      when(sketchNode.points).thenReturn([
        {
          'point': '{0,0}',
        },
        {
          'point': '{50,50}',
        },
      ]);

      when(sketchNode.boundaryRectangle)
          .thenReturn(Frame(x: 0, y: 0, width: 50, height: 50));

      when(sketchNode.do_objectID).thenReturn('');
      shapePath = InheritedShapePath(sketchNode, currentContext: context);
    });

    test('Detecting Shape', () {
      expect(shapePath.generator.runtimeType, PBBitmapGenerator);
    });
  });
}
