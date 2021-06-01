import 'dart:io';

import 'package:mockito/mockito.dart';
import 'package:parabeac_core/generation/generators/value_objects/file_structure_strategy/commands/file_structure_command.dart';
import 'package:parabeac_core/generation/generators/value_objects/file_structure_strategy/commands/write_screen_command.dart';
import 'package:parabeac_core/generation/generators/value_objects/file_structure_strategy/pb_file_structure_strategy.dart';
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
      command = WriteScreenCommand('UUID', 'test_screen.dart', '', screenData);
      strategy = MockFSStrategy();
      when(strategy.GENERATED_PROJECT_PATH).thenReturn('temp/');
    });

    test('Testing writing a screen', () async {
      await command.write(strategy);
      var verification = verify(strategy.writeDataToFile(
          captureAny, any, captureAny,
          UUID: anyNamed('UUID')));

      /// Make sure we are writting to the file using the strategy
      expect(verification.captured.first, screenData);
      expect(verification.callCount, 1);

      ///Make sure that we are using the same name for the file that is going to
      ///be written into the file system.
      expect(verification.captured.contains('test_screen.dart'), isTrue);
    });
  });
}
