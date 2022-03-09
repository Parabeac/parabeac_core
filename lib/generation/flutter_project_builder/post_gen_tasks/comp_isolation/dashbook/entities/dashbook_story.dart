import 'package:parabeac_core/generation/flutter_project_builder/post_gen_tasks/comp_isolation/dashbook/entities/dashbook_chapter.dart';
import 'package:parabeac_core/generation/flutter_project_builder/post_gen_tasks/comp_isolation/isolation_node.dart';

/// Node that represents a Widgetbook component.
class DashBookStory extends IsolationNode {
  DashBookStory(String name) : super(name: name);

  @override
  String generate() {
    var useCases = getType<DashBookChapter>();
    var useCasesGen = '';
    if (useCases != null && useCases.isNotEmpty) {
      useCasesGen = useCases.map((useCase) => useCase.generate()).join('\n');
    }
    return '''
      dashbook
      .storiesOf('$name')
      .decorator(CenterDecorator())
      $useCasesGen
      ;
    ''';
  }
}
