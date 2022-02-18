import 'package:parabeac_core/generation/flutter_project_builder/post_gen_tasks/comp_isolation/isolation_node.dart';
import 'package:parabeac_core/generation/flutter_project_builder/post_gen_tasks/comp_isolation/widgetbook/entities/widgetbook_use_case.dart';

/// Node that represents a Widgetbook component.
class WidgetBookWidget extends IsolationNode {
  WidgetBookWidget(String name) : super(name: name);

  @override
  String generate() {
    var useCases = getType<WidgetBookUseCase>();
    var useCasesGen = '';
    if (useCases != null && useCases.isNotEmpty) {
      useCasesGen = useCases.map((useCase) => useCase.generate()).join('\n');
    }
    return '''
      WidgetbookWidget(
        name: '$name',
        ${useCasesGen.isNotEmpty ? 'useCases: [\n$useCasesGen\n],\n' : ''}
      )
    ''';
  }
}
