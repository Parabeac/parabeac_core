import 'package:mockito/mockito.dart';
import 'package:parabeac_core/generation/generators/value_objects/file_structure_strategy/commands/file_structure_command.dart';
import 'package:parabeac_core/generation/generators/value_objects/file_structure_strategy/commands/write_symbol_command.dart';
import 'package:parabeac_core/generation/generators/value_objects/file_structure_strategy/pb_file_structure_strategy.dart';
import 'package:test/test.dart';

class MockFSStrategy extends Mock implements FileStructureStrategy {}

void main() {
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
      command = WriteSymbolCommand('UUID', 'test_symbol.dart', symData);
      strategy = MockFSStrategy();
      when(strategy.GENERATED_PROJECT_PATH).thenReturn('temp/');
    });

    test('Makes sure that the command is using the strategy to write a file',
        () async {
      await command.write(strategy);
      var verification = verify(strategy.writeDataToFile(
          captureAny, any, captureAny,
          UUID: anyNamed('UUID')));

      /// Make sure we are writting to the file using the strategy
      expect(verification.captured.first, symData);
      expect(verification.callCount, 1);

      ///Make sure that we are using the same name for the file that is going to
      ///be written into the file system.
      expect(verification.captured.contains('test_symbol.dart'), isTrue);
    });
  });
}
