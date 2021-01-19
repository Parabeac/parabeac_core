import 'package:parabeac_core/generation/generators/writers/pb_page_writer.dart';

/// Adapter used to traverse trees using generation
/// without actually writing to the tree itself.
///
/// As seen below, the methods overriden do nothing
/// and simply return. This is because this Adapter's
/// purpose allows use of the generation phase without
/// writing any files, which is useful for gathering and
/// writing information to nodes without outputting 
/// any code.
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
