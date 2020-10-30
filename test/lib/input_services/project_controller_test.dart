import 'dart:io';

import 'package:parabeac_core/APICaller/api_call_service.dart';
import 'package:parabeac_core/controllers/figma_controller.dart';
import 'package:parabeac_core/controllers/main_info.dart';
import 'package:parabeac_core/controllers/sketch_controller.dart';
import 'package:test/test.dart';

void main() {
  var figmaFileID = 'https://api.figma.com/v1/files/zXXWPWb5wJXd0ImGUjEU1X';
  var figmaAPIKey = '64522-f0e5502a-d2ce-4708-880b-c294e9cb20ed';
  group('Input to PBDL test', () {
    var result;
    var outputPath;
    var configurationPath = 'lib/configurations/configurations.json';
    var absPath =
        '/Volumes/Storage/Projects/Parabeac-Core/TestingSketch/parabeac_demo_alt.sketch';
    setUp(() async {
      outputPath = '/Volumes/Storage/Projects/Parabeac-Core/temp';
      MainInfo().cwd = Directory('/Volumes/Storage/Projects/Parabeac-Core');
      MainInfo().outputPath = outputPath;
      MainInfo().projectName = 'temp';

      /// For Figma input
      result = await APICallService.makeAPICall(figmaFileID, figmaAPIKey);
    });
    test('Figma Test', () async {
      await FigmaController()
          .convertFile(result, outputPath, configurationPath, 'default');
      // print(figmaNodeTree);

      print('hi');
    });
    test('Sketch Test', () {
      SketchController()
          .convertFile(absPath, outputPath, configurationPath, 'default');
      // print(sketchNodeTree);
      print('hi');
    });
  });
}
