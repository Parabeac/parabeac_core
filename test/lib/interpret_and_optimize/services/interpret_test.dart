import 'dart:io';

import 'package:parabeac_core/controllers/interpret.dart';
import 'package:parabeac_core/controllers/main_info.dart';
import 'package:parabeac_core/input/sketch/entities/layers/artboard.dart';
import 'package:parabeac_core/input/sketch/entities/layers/group.dart';
import 'package:parabeac_core/input/sketch/entities/layers/sketch_text.dart';
import 'package:parabeac_core/input/sketch/entities/objects/frame.dart';
import 'package:parabeac_core/input/sketch/helper/sketch_node_tree.dart';
import 'package:parabeac_core/input/sketch/helper/sketch_page.dart';
import 'package:parabeac_core/input/sketch/helper/sketch_page_item.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/inherited_container.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/alignments/injected_align.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/injected_container.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/layouts/temp_group_layout_node.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_context.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_intermediate_item.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_intermediate_node_tree.dart';
import 'package:parabeac_core/interpret_and_optimize/value_objects/point.dart';
import 'package:test/test.dart';
import 'package:mockito/mockito.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/inherited_scaffold.dart';

class MockNodeTree extends Mock implements SketchNodeTree {}

class MockPage extends Mock implements SketchPage {}

class MockPageItem extends Mock implements SketchPageItem {}

class MockArtboard extends Mock implements Artboard {
  @override
  Future<PBIntermediateNode> interpretNode(PBContext currentContext) {
    return Future.value(InheritedScaffold(
      this,
      currentContext: currentContext,
      name: name,
      isHomeScreen: isFlowHome,
    ));
  }
}

class MockGroup extends Mock implements Group {
  @override
  Future<PBIntermediateNode> interpretNode(PBContext currentContext) =>
      Future.value(TempGroupLayoutNode(this, currentContext, name,
          topLeftCorner: Point(boundaryRectangle.x, boundaryRectangle.y),
          bottomRightCorner: Point(
              boundaryRectangle.x + boundaryRectangle.width,
              boundaryRectangle.y + boundaryRectangle.height)));
}

class MockContainer extends Mock implements SketchText {
  @override
  Future<PBIntermediateNode> interpretNode(PBContext currentContext) =>
      Future.value(InheritedContainer(
        this,
        Point(boundaryRectangle.x, boundaryRectangle.y),
        Point(boundaryRectangle.x + boundaryRectangle.width,
            boundaryRectangle.y + boundaryRectangle.height),
        name,
        currentContext: currentContext,
      ));
}

void main() {
  MockNodeTree nodeTree;
  MockPage page;
  MockPageItem pageItem;
  MockArtboard artboard;
  MockGroup mockGroup;
  MockContainer container;
  group('Interpret test', () {
    setUp(() {
      Interpret().init(
          '${Directory.current.path}/test/lib/interpret_and_optimize/services');
      MainInfo().configurations = MainInfo().defaultConfigs;
      MainInfo().configurationType = 'default';

      nodeTree = MockNodeTree();
      page = MockPage();
      pageItem = MockPageItem();
      artboard = MockArtboard();
      mockGroup = MockGroup();
      container = MockContainer();

      when(nodeTree.pages).thenReturn([page]);
      when(page.getPageItems()).thenReturn([pageItem]);
      when(pageItem.root).thenReturn(artboard);
      when(artboard.children).thenReturn([mockGroup]);

      when(artboard.isVisible).thenReturn(true);
      when(artboard.isFlowHome).thenReturn(true);
      when(mockGroup.isVisible).thenReturn(true);
      when(container.isVisible).thenReturn(true);

      when(artboard.name).thenReturn('testArtboard');
      when(mockGroup.name).thenReturn('testGroup');
      when(container.name).thenReturn('testContainer');

      when(artboard.type).thenReturn('artboard');
      when(mockGroup.type).thenReturn('group');
      when(container.type).thenReturn('text');

      when(page.name).thenReturn('testName');
      when(mockGroup.children).thenReturn([container]);
      when(mockGroup.boundaryRectangle).thenReturn(Frame(
        x: 100,
        y: 100,
        width: 200,
        height: 200,
      ));
      when(artboard.boundaryRectangle).thenReturn(Frame(
        x: 100,
        y: 100,
        width: 200,
        height: 200,
      ));
      when(container.boundaryRectangle).thenReturn(Frame(
        x: 100,
        y: 100,
        width: 200,
        height: 200,
      ));
    });
    test('', () async {
      var mainTree = await Interpret().interpretAndOptimize(
        nodeTree,
      );
      expect(mainTree != null, true);
      expect(mainTree is PBIntermediateTree, true);
      expect(mainTree.rootItem is PBIntermediateItem, true);
      expect(mainTree.rootItem.node is InheritedScaffold, true);
      expect(mainTree.rootItem.node.child is InjectedAlign, true);
      expect(mainTree.rootItem.node.child.child is InjectedContainer, true);
    });
  });
}
