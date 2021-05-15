import 'dart:io';

import 'package:mockito/mockito.dart';
import 'package:parabeac_core/generation/generators/value_objects/file_structure_strategy/commands/add_dependency_command.dart';
import 'package:parabeac_core/generation/generators/value_objects/file_structure_strategy/commands/file_structure_command.dart';
import 'package:parabeac_core/generation/generators/value_objects/file_structure_strategy/pb_file_structure_strategy.dart';
import 'package:parabeac_core/generation/generators/writers/pb_flutter_writer.dart';
import 'package:test/test.dart';

class MockFSStrategy extends Mock implements FileStructureStrategy {}

class MockCommand extends Mock implements AddDependencyCommand {}

class MockFile extends Mock implements File {}

void main() {
  final path = '${Directory.current.path}/test/lib/generation/commands/';
  group('Add Dependency Command', () {
    AddDependencyCommand command;
    FileStructureStrategy strategy;
    List<String> yamlFileContents;
    File yamlFile;

    setUp(() {
      yamlFile = MockFile();
      command = MockCommand();
      strategy = MockFSStrategy();
      yamlFileContents = <String>['dependencies:', 'flutter:', '  assets:'];

      when(command.package).thenReturn('auto_size_text');
      when(command.version).thenReturn('^2.1.0');
      when(command.yamlFile).thenReturn(yamlFile);

      when(yamlFile.readAsLinesSync()).thenReturn(yamlFileContents);
      when(command.writeDataToFile('', '')).thenReturn(null);
      when(strategy.GENERATED_PROJECT_PATH).thenReturn('${path}tmptst');
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
