import 'dart:io';

import 'package:test/test.dart';

void main() {
  test('Figma Styling Test', () {
    const FIGMA_FILE_ID = 'AVFG9SWJOzJ4VAfM7uMVzr';
    const FIGMA_TOKEN = '346066-568dc332-c33e-4c5c-a99d-502bd135b572';
    final goldenStr = File('test/styling/styling.golden').readAsStringSync();

    /// Run parabeac-core and get generated file.
  });
}
