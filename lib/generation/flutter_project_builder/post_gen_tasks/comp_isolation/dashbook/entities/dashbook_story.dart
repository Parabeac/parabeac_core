import 'package:parabeac_core/generation/flutter_project_builder/post_gen_tasks/comp_isolation/dashbook/entities/dashbook_chapter.dart';
import 'package:parabeac_core/generation/flutter_project_builder/post_gen_tasks/comp_isolation/isolation_node.dart';

/// Node that represents a Widgetbook component.
class DashBookStory extends IsolationNode {
  DashBookStory(String name) : super(name: name);

  @override
  String generate() {
    var chapters = getType<DashBookChapter>();
    var chaptersGen = '';
    if (chapters != null && chapters.isNotEmpty) {
      chaptersGen = chapters.map((chapter) => chapter.generate()).join('\n');
    }
    return '''
      dashbook
      .storiesOf('$name')
      .decorator(CenterDecorator())
      $chaptersGen
      ;
    ''';
  }
}
