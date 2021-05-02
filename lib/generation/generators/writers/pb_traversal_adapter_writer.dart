import 'package:parabeac_core/generation/generators/writers/pb_page_writer.dart';

/// Adapter used to traverse trees using generation
/// without actually writing to the tree itself.
///
/// The adapter's purpose is to disregard requests to modify any files,
/// hence the empty return methods.
class PBTraversalAdapterWriter extends PBPageWriter {
  @override
  void addDependency(String packageName, String version) {
    return;
  }

  @override
  void write(String code, String fileName) {
    return;
  }

  @override
  void append(String code, String fileName) {
    return;
  }
}
