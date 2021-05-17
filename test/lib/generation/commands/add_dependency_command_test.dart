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
      /// Create sample YAML file
      var yaml = File('${path}tmptst/pubspec.yaml');
      yaml.createSync(recursive: true);
      yaml.writeAsStringSync('''
dependencies:
  json_serializable: ^3.5.0

flutter:
      ''');

      command = AddDependencyCommand('auto_size_text', '^2.1.0');
      strategy = MockFSStrategy();
      when(strategy.GENERATED_PROJECT_PATH).thenReturn('${path}tmptst');
      when(strategy.pageWriter).thenReturn(PBFlutterWriter());
    });

    test('Testing adding a dependency', () async {
      await command.write(strategy);
      var fileStr = File('${path}tmptst/pubspec.yaml').readAsStringSync();
      expect(fileStr.contains('auto_size_text: ^2.1.0'), true);
      expect(fileStr.contains('- assets/images/'), true);
    });
  });
}
