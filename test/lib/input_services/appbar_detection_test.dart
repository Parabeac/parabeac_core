import 'package:mockito/mockito.dart';
import 'package:parabeac_core/eggs/injected_app_bar.dart';
import 'package:parabeac_core/input/sketch/entities/layers/abstract_layer.dart';
import 'package:parabeac_core/input/sketch/entities/objects/frame.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_context.dart';
import 'package:parabeac_core/generation/generators/plugins/pb_plugin_node.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_plugin_list_helper.dart';
import 'package:test/test.dart';

class SketchNodeMock extends Mock implements SketchNode {}

class ContextMock extends Mock implements PBContext {}

void main() {
  group('Detecting appbar from semantic', () {
    SketchNodeMock sketchNode;
    PBPluginListHelper helper;
    ContextMock context;
    setUp(() {
      context = ContextMock();
      helper = PBPluginListHelper();
      helper.initPlugins(context);
      sketchNode = SketchNodeMock();
      when(sketchNode.name).thenReturn('element.*navbar');
      when(sketchNode.boundaryRectangle)
          .thenReturn(Frame(x: 0, y: 0, width: 300, height: 20));
    });

    test('Checking for appbar', () {
      PBEgg pNode = helper.returnAllowListNodeIfExists(sketchNode);
      expect(pNode.runtimeType, InjectedNavbar);
    });
  });
}
