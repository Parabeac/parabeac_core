import 'package:parabeac_core/controllers/main_info.dart';
import 'package:parabeac_core/generation/flutter_project_builder/import_helper.dart';
import 'package:parabeac_core/generation/flutter_project_builder/post_gen_tasks/comp_isolation/component_isolation_generator.dart';
import 'package:parabeac_core/generation/generators/import_generator.dart';
import 'package:parabeac_core/generation/generators/util/pb_generation_project_data.dart';
import 'package:parabeac_core/interpret_and_optimize/services/component_isolation/widgetbook_service.dart';

class WidgetbookGenerator implements ComponentIsolationGenerator {
  @override
  String fileName = 'main_widgetbook.dart';

  WidgetbookGenerator(this.projectData) {
    projectData.addDependencies('widgetbook', '2.0.5-beta');
  }

  @override
  PBGenerationProjectData projectData;

  @override
  String generateCode(ImportHelper helper) {
    var category = WidgetBookService.category;
    var treeIds = WidgetBookService.treeIds;
    var generatedCode = category.generate();

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
    import 'package:widgetbook/widgetbook.dart';
    import 'package:flutter/material.dart';
    $imports

    void main() {
      runApp(const MyApp());
    }

    class MyApp extends StatelessWidget {
      const MyApp({Key? key}) : super(key: key);

      @override
      Widget build(BuildContext context){
        return Widgetbook(
          themes: [
            WidgetbookTheme(name: 'Light', data: ThemeData.light()),
          ],
          devices: const [
            Apple.iPhone11ProMax,
            Samsung.s10,
          ],
          categories: [
            $generatedCode,
          ],
          appInfo: AppInfo(name: 'MyApp'),
        );
      }
    }
    ''';
  }
}
