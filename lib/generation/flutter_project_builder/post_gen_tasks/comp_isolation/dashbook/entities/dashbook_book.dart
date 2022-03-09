import 'package:parabeac_core/generation/flutter_project_builder/post_gen_tasks/comp_isolation/dashbook/entities/dashbook_story.dart';
import 'package:parabeac_core/generation/flutter_project_builder/post_gen_tasks/comp_isolation/isolation_node.dart';

/// Class that represents a DashBook Book.
class DashBookBook extends IsolationNode {
  DashBookBook({
    String name = 'Parabeac-Generated',
  }) : super(name: name);

  @override
  String generate() {
    var stories = getType<DashBookStory>();

    var storiesGen = '';

    if (stories != null && stories.isNotEmpty) {
      storiesGen = stories.map((s) => s.generate()).join('\n');
    }
    return '''
      ${storiesGen.isNotEmpty ? ' $storiesGen\n' : ''}
    ''';
  }
}
