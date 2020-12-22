import 'package:parabeac_core/generation/generators/attribute-helper/pb_color_gen_helper.dart';
import 'package:parabeac_core/generation/generators/pb_generator.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/inherited_scaffold.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';

class PBScaffoldGenerator extends PBGenerator {
  PBScaffoldGenerator() : super();

  @override
  String generate(PBIntermediateNode source) {
    if (source is InheritedScaffold) {
      var buffer = StringBuffer();
      buffer.write('Scaffold(\n');

      if (source.auxiliaryData.color != null) {
        var str = PBColorGenHelper().generate(source);
        buffer.write(str);
      }
      if (source.navbar != null) {
        buffer.write('appBar: ');
        var appbar = manager.generate(source.navbar);
        buffer.write('$appbar,\n');
      }
      if (source.tabbar != null) {
        buffer.write('bottomNavigationBar: ');
        var navigationBar = manager.generate(source.tabbar);
        buffer.write('$navigationBar, \n');
      }

      if (source.child != null) {
        // hack to pass screen width and height to the child
        buffer.write('body: ');
        var body = manager.generate(source.child);
        buffer.write('$body, \n');
      }
      buffer.write(')');
      return buffer.toString();
    }
  }
}
