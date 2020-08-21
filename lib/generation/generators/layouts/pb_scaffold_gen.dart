import 'package:parabeac_core/generation/generators/attribute-helper/pb_color_gen_helper.dart';
import 'package:parabeac_core/generation/generators/pb_generator.dart';
import 'package:parabeac_core/generation/generators/pb_widget_manager.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/inherited_scaffold.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';

import '../pb_flutter_generator.dart';

class PBScaffoldGenerator extends PBGenerator {
  // final PBGenerationManager manager;

  PBScaffoldGenerator() : super('Scaffold');

  @override
  String generate(PBIntermediateNode source) {
    if (source is InheritedScaffold) {
      var buffer = StringBuffer();
      buffer.write('Scaffold(\n');
      if (source.backgroundColor != null) {
        var str = PBColorGenHelper().generate(source);
        buffer.write(str);
      }
      if (source.navbar != null) {
        buffer.write('appBar: ');
        var appbar =
            manager.generate(source.navbar, type: BUILDER_TYPE.SCAFFOLD_BODY);
        buffer.write('$appbar,\n');
      }
      if (source.tabbar != null) {
        buffer.write('bottomNavigationBar: ');
        var navigationBar =
            manager.generate(source.tabbar, type: BUILDER_TYPE.SCAFFOLD_BODY);
        buffer.write('$navigationBar, \n');
      }

      if (source.child != null) {
        // hack to pass screen width and height to the child
        buffer.write('body: ');
        var body =
            manager.generate(source.child, type: BUILDER_TYPE.SCAFFOLD_BODY);
        buffer.write('$body, \n');
      }
      buffer.write(')');
      return buffer.toString();
    }
  }
}
