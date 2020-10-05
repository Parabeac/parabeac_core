import 'package:parabeac_core/eggs/injected_app_bar.dart';
import 'package:parabeac_core/generation/generators/pb_generator.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';

class PBCupertinoSearchBar extends PBGenerator {
  PBCupertinoSearchBar() : super();

  @override
  String generate(PBIntermediateNode source) {
    if (source is InjectedNavbar) {
      var buffer = StringBuffer();
      buffer.write('AppBar(');
      if (source.leadingItem != null) {
        buffer.write('leading: ${source.leadingItem}');
      }
      if (source.middleItem != null) {
        buffer.write('middleItem: ${source.middleItem}');
      }
      if (source.trailingItem) {
        buffer.write('trailingItem: ${source.trailingItem}');
      }
      buffer.write(')');
      return buffer.toString();
    }
    return '';
  }
}
