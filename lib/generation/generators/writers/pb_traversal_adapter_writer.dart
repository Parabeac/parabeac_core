import 'package:parabeac_core/generation/generators/writers/pb_page_writer.dart';
import 'package:parabeac_core/input/sketch/entities/style/font_descriptor.dart';

/// Adapter used to traverse trees using generation
/// without actually writing to the tree itself.
///
/// TODO: add more detail to purpose of empty methods.
class PBTraversalAdapterWriter extends PBPageWriter {
  @override
  void addDependency(String packageName, String version) {
    return;
  }

  @override
  void addFont(FontDescriptor fd) {
    return;
  }

  @override
  void write(String code, String fileName) {
    return;
  }
}
