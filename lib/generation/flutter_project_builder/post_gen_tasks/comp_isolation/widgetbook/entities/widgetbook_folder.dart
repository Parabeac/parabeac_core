import 'package:parabeac_core/generation/flutter_project_builder/post_gen_tasks/comp_isolation/isolation_node.dart';
import 'package:parabeac_core/generation/flutter_project_builder/post_gen_tasks/comp_isolation/widgetbook/entities/widgetbook_widget.dart';

class WidgetBookFolder extends IsolationNode {
  WidgetBookFolder(String name) : super(name: name);

  @override
  String generate() {
    var widgets = getType<WidgetBookWidget>();
    var genWidgets = '';
    if (widgets != null && widgets.isNotEmpty) {
      genWidgets = widgets.map((node) => node.generate()).join(',\n');
    }
    return '''
      WidgetbookFolder(
        name: '$name',
        ${genWidgets.isNotEmpty ? 'widgets: [\n$genWidgets\n],\n' : ''}
      )
    ''';
  }
}
