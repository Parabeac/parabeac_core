import 'package:parabeac_core/generation/flutter_project_builder/post_gen_tasks/comp_isolation/isolation_node.dart';

class DashBookChapter extends IsolationNode {
  String builderCode;
  DashBookChapter(String name, this.builderCode) : super(name: name);

  @override
  String generate() {
    return '''
      .add('$name',
          (ctx) => $builderCode)
    ''';
  }
}
