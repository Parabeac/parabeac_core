import 'package:parabeac_core/controllers/main_info.dart';
import 'package:parabeac_core/generation/flutter_project_builder/import_helper.dart';
import 'package:parabeac_core/generation/flutter_project_builder/post_gen_tasks/comp_isolation/component_isolation_generator.dart';
import 'package:parabeac_core/generation/generators/import_generator.dart';
import 'package:parabeac_core/generation/generators/util/pb_generation_project_data.dart';
import 'package:parabeac_core/interpret_and_optimize/services/component_isolation/dashbook_service.dart';

class DashbookGenerator implements ComponentIsolationGenerator {
  @override
  String fileName = 'main_dashbook.dart';

  DashbookGenerator(this.projectData) {
    projectData.addDependencies('dashbook', '^0.1.6');
  }

  @override
  PBGenerationProjectData projectData;

  @override
  String generateCode(ImportHelper helper) {
    var book = DashbookService.book;
    var treeIds = DashbookService.treeIds;
    var generatedCode = book.generate();

    var imports = treeIds
        .map(
          (id) => helper
              .getFormattedImports(
                id,
                importMapper: (import) => FlutterImport(
                  import,
                  MainInfo().projectName,
                ),
              )
              .join('\n'),
        )
        .join('');
    return '''
    import 'package:flutter/material.dart';
    import 'package:dashbook/dashbook.dart';
    $imports

    void main() {
      final dashbook = Dashbook();

      $generatedCode

      runApp(dashbook);
    }
    ''';
  }
}
