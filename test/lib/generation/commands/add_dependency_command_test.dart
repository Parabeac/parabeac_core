import 'dart:io';

import 'package:mockito/mockito.dart';
import 'package:parabeac_core/generation/generators/value_objects/file_structure_strategy/commands/add_dependency_command.dart';
import 'package:parabeac_core/generation/generators/value_objects/file_structure_strategy/commands/file_structure_command.dart';
import 'package:parabeac_core/generation/generators/value_objects/file_structure_strategy/pb_file_structure_strategy.dart';
import 'package:parabeac_core/generation/generators/writers/pb_flutter_writer.dart';
import 'package:test/test.dart';

class MockFSStrategy extends Mock implements FileStructureStrategy {}

void main() {
  final path = '${Directory.current.path}/test/lib/generation/commands/';
  group('Add Dependency Command', () {
    FileStructureCommand command;
    FileStructureStrategy strategy;

    setUp(() {
      command = AddDependencyCommand('auto_size_text', '^2.1.0');
      strategy = MockFSStrategy();
      when(strategy.GENERATED_PROJECT_PATH).thenReturn('${path}tmptst/');
      when(strategy.pageWriter).thenReturn(PBFlutterWriter());
    });

    test('Testing adding a dependency', () async {
      await command.write(strategy);
      var dependencies = strategy.pageWriter.dependencies;
      expect(dependencies.isNotEmpty, true);
      expect(dependencies.containsKey('auto_size_text'), true);
      expect(dependencies['auto_size_text'], '^2.1.0');
    });
  });
}
