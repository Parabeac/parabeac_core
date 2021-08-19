import 'dart:math';
import 'package:mockito/mockito.dart';
import 'package:parabeac_core/eggs/injected_app_bar.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_context.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_intermediate_node_tree.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_plugin_list_helper.dart';
import 'package:test/test.dart';

class PBINodeMock extends Mock implements PBIntermediateNode {}

class ContextMock extends Mock implements PBContext {}

class MockPBITree extends Mock implements PBIntermediateTree {}

void main() {
  group('Detecting appbar from semantic', () {
    PBINodeMock pbiNodeMock;
    PBPluginListHelper helper;
    ContextMock context;
    MockPBITree mockTree;
    setUp(() {
      context = ContextMock();
      helper = PBPluginListHelper();
      helper.initPlugins(context);
      pbiNodeMock = PBINodeMock();
      mockTree = MockPBITree();
      when(pbiNodeMock.name).thenReturn('element<navbar>');
      when(pbiNodeMock.frame).thenReturn(Rectangle(0, 0, 300, 20));
      when(mockTree.childrenOf(any))
          .thenReturn(<PBIntermediateNode>[pbiNodeMock]);
    });

    test('Checking for appbar', () {
      var pNode = helper.returnAllowListNodeIfExists(pbiNodeMock, mockTree);
      expect(pNode.runtimeType, InjectedAppbar);
    });
  });
}
