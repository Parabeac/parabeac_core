import 'dart:io';

import 'package:mockito/mockito.dart';
import 'package:parabeac_core/generation/generators/value_objects/file_structure_strategy/commands/add_constant_command.dart';
import 'package:parabeac_core/generation/generators/value_objects/file_structure_strategy/commands/file_structure_command.dart';
import 'package:parabeac_core/generation/generators/value_objects/file_structure_strategy/pb_file_structure_strategy.dart';
import 'package:parabeac_core/generation/generators/writers/pb_flutter_writer.dart';
import 'package:test/test.dart';

class MockFSStrategy extends Mock implements FileStructureStrategy {}

void main() {
  final path = '${Directory.current.path}/test/lib/generation/commands/';
  group('Add Constant Command', () {
    var strategy;
    FileStructureCommand const1;
    FileStructureCommand const2;
    setUp(() {
      // Create temporary directory to output files
      Process.runSync('mkdir', ['tmptst'], workingDirectory: path);

      strategy = MockFSStrategy();
      const1 = AddConstantCommand('c1', 'String', '\'test\'');
      const2 = AddConstantCommand('c2', 'int', '20');
      when(strategy.GENERATED_PROJECT_PATH).thenReturn('${path}tmptst/');
      when(strategy.pageWriter).thenReturn(PBFlutterWriter());
    });
    test('Testing Adding Constants To Project', () async {
      final constPath = '${path}tmptst/lib/constants/constants.dart';
      await const1.write(strategy);
      await const2.write(strategy);
      expect(File(constPath).existsSync(), true);
      var constFile = File(constPath).readAsStringSync();
      expect(constFile.contains('const String c1 = \'test\''), true);
      expect(constFile.contains('const int c2 = 20'), true);
    });
    tearDownAll(() {
      Process.runSync('rm', ['-r', 'tmptst'], workingDirectory: path);
    });
  });
}
