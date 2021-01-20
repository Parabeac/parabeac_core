import 'package:parabeac_core/generation/generators/writers/pb_page_writer.dart';

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
  void write(String code, String fileName) {
    return;
  }
}
