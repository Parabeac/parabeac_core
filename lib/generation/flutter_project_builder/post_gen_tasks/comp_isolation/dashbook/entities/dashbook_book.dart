import 'package:parabeac_core/generation/flutter_project_builder/post_gen_tasks/comp_isolation/dashbook/entities/dashbook_story.dart';
import 'package:parabeac_core/generation/flutter_project_builder/post_gen_tasks/comp_isolation/isolation_node.dart';

/// Class that represents a group of [DashBookStories].
/// 
/// This class does not actually exist in Dashbook. However,
/// it makes it easier for us to group stories and generate them
/// in a single step.
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
