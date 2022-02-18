import 'package:parabeac_core/generation/flutter_project_builder/post_gen_tasks/comp_isolation/isolation_node.dart';

class WidgetBookUseCase extends IsolationNode {
  String builderCode;
  WidgetBookUseCase(String name, this.builderCode) : super(name: name);

  @override
  String generate() {
    return '''
      WidgetbookUseCase(
        name: '$name',
        builder: (context) => Center(child: $builderCode),
      ),
    ''';
  }
}
