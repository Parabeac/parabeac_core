import 'dart:io';
import 'package:parabeac_core/controllers/figma_controller.dart';
import 'package:parabeac_core/controllers/main_info.dart';
import 'package:parabeac_core/controllers/sketch_controller.dart';
import 'package:parabeac_core/input/figma/helper/api_call_service.dart';
import 'package:parabeac_core/input/figma/helper/figma_page.dart';
import 'package:parabeac_core/input/figma/helper/figma_project.dart';
import 'package:parabeac_core/input/sketch/helper/sketch_page.dart';
import 'package:parabeac_core/input/sketch/helper/sketch_project.dart';
import 'package:parabeac_core/input/sketch/services/input_design.dart';
import 'package:test/test.dart';

void main() {
  var figmaFileID = 'https://api.figma.com/v1/files/zXXWPWb5wJXd0ImGUjEU1X';
  var figmaAPIKey = Platform.environment['FIG_API_KEY'];
  group(
    'Input to PBDL test',
    () {
      var result;
      var outputPath;
      var ids;
      setUp(() async {
        outputPath = '${Directory.current.path}/temp/';
        MainInfo().outputPath = outputPath;

        /// For Figma input
        result = await APICallService.makeAPICall(figmaFileID, figmaAPIKey);

        /// For Sketch Input
        ids = InputDesignService(
            '${Directory.current.path}/test/assets/parabeac_demo_alt.sketch');
      });
      test('Figma Test', () async {
        var figmaNodeTree =
            await FigmaController().generateFigmaTree(result, outputPath);

        expect(figmaNodeTree != null, true);
        expect(figmaNodeTree is FigmaProject, true);
        expect(figmaNodeTree.pages.isNotEmpty, true);
        expect(figmaNodeTree.pages[0] is FigmaPage, true);
      });
      test('Sketch Test', () {
        var sketchNodeTree = SketchController().generateSketchNodeTree(
            ids, ids.metaFileJson['pagesAndArtboards'], outputPath);

        expect(sketchNodeTree != null, true);
        expect(sketchNodeTree is SketchProject, true);
        expect(sketchNodeTree.pages.isNotEmpty, true);
        expect(sketchNodeTree.pages[0] is SketchPage, true);
      });
      tearDownAll(() {
        Process.runSync(
            '${Directory.current.path}/lib/generation/helperScripts/shell-proxy.sh',
            ['rm -rf ${outputPath}']);
      });
    },
    skip: !Platform.environment.containsKey('FIG_API_KEY'),
  );
}
