import 'dart:convert';
import 'dart:io';

import 'package:parabeac_core/controllers/main_info.dart';
import 'package:parabeac_core/input/sketch/helper/svg_png_convertion.dart';
import 'package:test/test.dart';

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

      /// Need to ensure Sketch Asset Converter is installed and running
      await Process.start('bash', [
        '${Directory.current.path}/pb-scripts/install.sh',
      ]);
      process = await Process.start('npm', ['run', 'prod'],
          workingDirectory: '${Directory.current.path}/SketchAssetConverter');
      await for (var event in process.stdout.transform(utf8.decoder)) {
        if (event.toLowerCase().contains('server is listening on port')) {
          break;
        }
      }
    });

    test('Testing Image Conversion', () async {
      for (var uuid in uuids) {
        var image = await convertImageLocal(uuid, 23, 21);
        expect(image, isNot(null));
      }
    });

    tearDownAll(() {
      process.kill();
    });
  });
}
