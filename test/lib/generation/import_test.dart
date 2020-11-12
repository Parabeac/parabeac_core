import 'package:mockito/mockito.dart';
import 'package:parabeac_core/generation/flutter_project_builder/import_helper.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_gen_cache.dart';
import 'package:test/test.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';

class NodeMock extends Mock implements PBIntermediateNode {}

void main() {
  // Will test IntermediateNode that needs imports
  // and an IntermediateNode without imports
  var iNodeWithImports, iNodeWithoutImports;

  /// Three intermediateNodes that will generate import
  var importee1, importee2, importee3;
  var genCache;
  group('Import test', () {
    setUp(() {
      iNodeWithImports = NodeMock();
      iNodeWithoutImports = NodeMock();
      importee1 = NodeMock();
      importee2 = NodeMock();
      importee3 = NodeMock();
      genCache = PBGenCache();

      when(iNodeWithImports.UUID).thenReturn('00-00-00');
      when(iNodeWithoutImports.UUID).thenReturn('00-01-00');
      when(importee1.UUID).thenReturn('00-00-01');
      when(importee2.UUID).thenReturn('00-00-02');
      when(importee3.UUID).thenReturn('00-00-03');

      when(iNodeWithImports.child).thenReturn(importee1);
      when(importee1.child).thenReturn(importee2);
      when(importee2.child).thenReturn(importee3);
    });

    test('Testing import generation when imports are generated', () {
      //Add symbol in the same folder as importer
      genCache.addToCache(importee1.UUID, '/path/to/page/importee1.dart');
      //Add symbol located a directory above importer
      genCache.addToCache(importee2.UUID, '/path/to/importee2.dart');
      //Add symbol located a directory below importer
      genCache.addToCache(importee3.UUID, '/path/to/page/sub/importee3.dart');

      // Find the imports of importer.dart
      var imports = ImportHelper.findImports(
          iNodeWithImports, '/path/to/page/importer.dart');

      expect(imports.length, 3);
      expect(imports[0], './importee1.dart');
      expect(imports[1], '../importee2.dart');
      expect(imports[2], './sub/importee3.dart');
    });

    test('Testing import generation when no imports are generated', () {
      var noImports = ImportHelper.findImports(
          iNodeWithoutImports, '/path/to/page/not_importer.dart');
      expect(noImports.length, 0);
    });
  });
}
