import 'package:parabeac_core/generation/flutter_project_builder/post_gen_tasks/comp_isolation/isolation_node.dart';
import 'package:parabeac_core/generation/flutter_project_builder/post_gen_tasks/comp_isolation/widgetbook/entities/widgetbook_folder.dart';
import 'package:parabeac_core/generation/flutter_project_builder/post_gen_tasks/comp_isolation/widgetbook/entities/widgetbook_widget.dart';

/// Class that represents a WidgetBook Category.
class WidgetBookCategory extends IsolationNode {
  WidgetBookCategory({
    String name = 'Parabeac-Generated',
  }) : super(name: name);

  @override
  String generate() {
    var folders = getType<WidgetBookFolder>();
    var widgets = getType<WidgetBookWidget>();

    var folderGen = '';
    var widgetsGen = '';

    if (folders != null && folders.isNotEmpty) {
      folderGen = folders.map((f) => f.generate()).join('\n');
    }
    if (widgets != null && widgets.isNotEmpty) {
      widgetsGen = widgets.map((w) => w.generate()).join('\n');
    }
    return '''
      WidgetbookCategory(
        name: 'Parabeac-Generated',
        ${folderGen.isNotEmpty ? 'folders: [\n$folderGen\n],\n' : ''}
        ${widgetsGen.isNotEmpty ? 'widgets: [\n$widgetsGen\n],\n' : ''}
      )
    ''';
  }
}
