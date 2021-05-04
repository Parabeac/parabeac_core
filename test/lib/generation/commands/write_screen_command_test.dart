import 'dart:io';

import 'package:mockito/mockito.dart';
import 'package:parabeac_core/generation/generators/value_objects/file_structure_strategy/commands/file_structure_command.dart';
import 'package:parabeac_core/generation/generators/value_objects/file_structure_strategy/commands/write_screen_command.dart';
import 'package:parabeac_core/generation/generators/value_objects/file_structure_strategy/pb_file_structure_strategy.dart';
import 'package:parabeac_core/generation/generators/writers/pb_flutter_writer.dart';
import 'package:test/test.dart';

class MockFSStrategy extends Mock implements FileStructureStrategy {}

void main() {
  final path = '${Directory.current.path}/test/lib/generation/commands/';
  final screenData = '''
  import 'package:flutter/material.dart';

  class TestScreen extends StatefulWidget {
    const TestScreen() : super();
    @override
    _TestScreen createState() => _TestScreen();
  }

  class _TestScreen extends State<TestScreen> {
    _TestScreen();

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        body: Container(),
      );
    }

    @override
    void dispose() {
      super.dispose();
    }
  }
  ''';
  group('Add Screen Command', () {
    FileStructureCommand command;
    FileStructureStrategy strategy;

    setUp(() {
      command = WriteScreenCommand('test_screen.dart', 'screens', screenData);
      strategy = MockFSStrategy();
      when(strategy.GENERATED_PROJECT_PATH).thenReturn('${path}tmptst/');
      when(strategy.pageWriter).thenReturn(PBFlutterWriter());
    });

    test('Testing writing a screen', () {
      var screenPath = '${path}tmptst/lib/modules/screens/test_screen.dart';
      var screenFile = File(screenPath);
      command.write(strategy);
      expect(screenFile.existsSync(), true);
      expect(screenFile.readAsStringSync().contains(screenData), true);
    });
    tearDownAll(() {
      Process.runSync('rm', ['-r', 'tmptst'], workingDirectory: path);
    });
  });
}
