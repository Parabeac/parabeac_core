import 'dart:io';

import 'package:mockito/mockito.dart';
import 'package:parabeac_core/generation/generators/value_objects/file_structure_strategy/commands/add_constant_command.dart';
import 'package:parabeac_core/generation/generators/value_objects/file_structure_strategy/commands/file_structure_command.dart';
import 'package:parabeac_core/generation/generators/value_objects/file_structure_strategy/pb_file_structure_strategy.dart';
import 'package:test/test.dart';

class MockFSStrategy extends Mock implements FileStructureStrategy {}

void main() {
  group('Add Constant Command', () {
    var strategy;
    FileStructureCommand const1;
    var const1V = <String>['c1', 'String', '\'test\''];

    FileStructureCommand const2;
    var const2V = <String>['c2', 'int', '20'];

    setUp(() {
      strategy = MockFSStrategy();
      const1 = AddConstantCommand(const1V[0], const1V[1], const1V[2]);
      const2 = AddConstantCommand(const2V[0], const2V[1], const2V[2]);
      when(strategy.GENERATED_PROJECT_PATH).thenReturn('temp/');
    });
    test('Testing Adding Constants To Project', () async {
      await const1.write(strategy);
      await const2.write(strategy);

      var verification =
          verify(strategy.appendDataToFile(captureAny, any, any));

      var capturedFuncs = verification.captured.whereType<ModFile>();

      var data = capturedFuncs
          .map((ModFile mod) => mod([]))
          .reduce((value, element) => value + element);

      expect(verification.callCount, 2);
      expect(data, [
        'const ${const1V[1]} ${const1V[0]} = ${const1V[2]};',
        'const ${const2V[1]} ${const2V[0]} = ${const2V[2]};'
      ]);
    });
  });
}
