import 'dart:convert';
import 'dart:io';

import 'package:parabeac_core/controllers/main_info.dart';
import 'package:parabeac_core/input/sketch/helper/svg_png_convertion.dart';
import 'package:test/test.dart';
import 'package:parabeac_core/input/figma/helper/image_helper.dart';

void main() async {
  var process;
  var uuids;

  group('Sketch PNG Testing', () {
    setUpAll(() async {
      MainInfo().sketchPath =
          '${Directory.current.path}/test/assets/parabeac_demo_alt.sketch';
      uuids = [
        '85D93FCD-5A69-4DAF-AE90-351CD9B64554', // Shape Group
        'B12B62C2-D7E3-452E-963E-A24216DD0942', // Shape Path
      ];
    });

    test('Testing Image Conversion', () async {
      for (var uuid in uuids) {
        var image = await convertImageLocal(uuid, 23, 21);
        expect(image, isNot(null));
      }
    });
  });

  group('Figma PNG Testing', () {
    setUpAll(() {
      MainInfo().figmaKey = Platform.environment['FIG_API_KEY'];
      MainInfo().figmaProjectID = 'zXXWPWb5wJXd0ImGUjEU1X';
      MainInfo().outputPath = '${Directory.current.path}/test/tmp/';
      uuidQueue.addAll([
        '0:12', // Boolean operation
        '0:15', // Group
        '0:31', // Ellipse
        '0:57', // Rectangle
      ]);
    });

    test('Testing Image Conversion', () async {
      await processImageQueue();
      for (var uuid in uuidQueue) {
        expect(
            File('${MainInfo().outputPath}pngs/$uuid.png'.replaceAll(':', '_'))
                .existsSync(),
            true);
      }
    });

    tearDownAll(() {
      Process.runSync('rm', ['-rf', '${Directory.current.path}/test/tmp/']);
    });
  },
      skip: !Platform.environment.containsKey('FIG_API_KEY'),
      timeout: Timeout(Duration(minutes: 1)));
}
