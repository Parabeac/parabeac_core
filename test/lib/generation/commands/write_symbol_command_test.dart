import 'dart:io';

import 'package:mockito/mockito.dart';
import 'package:parabeac_core/generation/generators/value_objects/file_structure_strategy/commands/file_structure_command.dart';
import 'package:parabeac_core/generation/generators/value_objects/file_structure_strategy/commands/write_symbol_command.dart';
import 'package:parabeac_core/generation/generators/value_objects/file_structure_strategy/pb_file_structure_strategy.dart';
import 'package:parabeac_core/generation/generators/writers/pb_flutter_writer.dart';
import 'package:test/test.dart';

class MockFSStrategy extends Mock implements FileStructureStrategy {}

void main() {
  final path = '${Directory.current.path}/test/lib/generation/commands/';
  final symData = '''
  import 'package:flutter/material.dart';

  class TestSymbol extends State<TestScreen> {
    TestSymbol();

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
  group('Add Symbol Command', () {
    FileStructureCommand command;
    FileStructureStrategy strategy;

    setUp(() {
      command = WriteSymbolCommand('test_symbol.dart', symData);
      strategy = MockFSStrategy();
      when(strategy.GENERATED_PROJECT_PATH).thenReturn('${path}tmptst/');
      when(strategy.pageWriter).thenReturn(PBFlutterWriter());
    });

    test('Testing writing a symbol', () async {
      var screenPath = '${path}tmptst/lib/widgets/test_symbol.dart';
      var screenFile = File(screenPath);
      var commandPath = await command.write(strategy);

      // The return of WriteSymbolCommand is `String`
      // ignore: unrelated_type_equality_checks
      expect(screenPath == commandPath, true);
      expect(screenFile.existsSync(), true);
      expect(screenFile.readAsStringSync().contains(symData), true);
    });
    tearDownAll(() {
      Process.runSync('rm', ['-r', 'tmptst'], workingDirectory: path);
    });
  });
}
