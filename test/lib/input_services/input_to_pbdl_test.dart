import 'package:parabeac_core/APICaller/api_call_service.dart';
import 'package:parabeac_core/controllers/figma_controller.dart';
import 'package:parabeac_core/controllers/sketch_controller.dart';
import 'package:parabeac_core/input/figma/helper/figma_node_tree.dart';
import 'package:parabeac_core/input/figma/helper/figma_page.dart';
import 'package:parabeac_core/input/sketch/helper/sketch_node_tree.dart';
import 'package:parabeac_core/input/sketch/helper/sketch_page.dart';
import 'package:parabeac_core/input/sketch/services/input_design.dart';
import 'package:test/test.dart';
import 'package:mockito/mockito.dart';

void main() {
  var figmaFileID = 'https://api.figma.com/v1/files/zXXWPWb5wJXd0ImGUjEU1X';
  var figmaAPIKey = '64522-f0e5502a-d2ce-4708-880b-c294e9cb20ed';
  group('Input to PBDL test', () {
    var result;
    var outputPath;
    var ids;
    setUp(() async {
      outputPath = 'Volumes/Storage/Projects/Parabeac-Core/temp';

      /// For Figma input
      result = await APICallService.makeAPICall(figmaFileID, figmaAPIKey);

      /// For Sketch Input
      ids = InputDesignService(
          '/Volumes/Storage/Projects/Parabeac-Core/TestingSketch/parabeac_demo_alt.sketch');
    });
    test('Figma Test', () async {
      var figmaNodeTree =
          await FigmaController().generateFigmaTree(result, outputPath);

      expect(figmaNodeTree != null, true);
      expect(figmaNodeTree is FigmaNodeTree, true);
      expect(figmaNodeTree.pages.isNotEmpty, true);
      expect(figmaNodeTree.pages[0] is FigmaPage, true);
    });
    test('Sketch Test', () {
      var sketchNodeTree = SketchController().generateSketchNodeTree(
          ids.archive, ids.metaFileJson['pagesAndArtboards'], outputPath);

      expect(sketchNodeTree != null, true);
      expect(sketchNodeTree is SketchNodeTree, true);
      expect(sketchNodeTree.pages.isNotEmpty, true);
      expect(sketchNodeTree.pages[0] is SketchPage, true);
    });
  });
}
