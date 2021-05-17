import 'dart:io';

import 'package:mockito/mockito.dart';
import 'package:parabeac_core/generation/generators/value_objects/file_structure_strategy/commands/add_dependency_command.dart';
import 'package:parabeac_core/generation/generators/value_objects/file_structure_strategy/pb_file_structure_strategy.dart';
import 'package:test/test.dart';

class MockFSStrategy extends Mock implements FileStructureStrategy {}

class MockFile extends Mock implements File {}

void main() {
  group('Add Dependency Command', () {
    AddDependencyCommand command;
    FileStructureStrategy strategy;
    var package;
    var version;

    setUp(() {
      package = 'auto_size_text';
      version = '^2.1.0';
      command = AddDependencyCommand(package, version);
      strategy = MockFSStrategy();
    });

    test('Testing the addition of package and asset path', () {
      command.write(strategy);
      var captured = verify(strategy.appendDataToFile(captureAny, any, any,
              createFileIfNotFound: false))
          .captured
          .first as ModFile;
      expect(captured(['dependencies:', 'flutter:', '  assets:']), [
        'dependencies:',
        '$package: $version',
        'flutter:',
        '  assets:',
        '\t\t- assets/images/'
      ]);
    });
  });
}
