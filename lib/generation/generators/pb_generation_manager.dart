import 'package:parabeac_core/generation/flutter_project_builder/import_helper.dart';
import 'package:parabeac_core/generation/generators/util/pb_generation_view_data.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_gen_cache.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';

/// Resposible for generating the code of a [PBIntermediateNode] Tree.
///
/// Furthermore, it provides a set of method that allows [PBIntermediateNode]s to add
/// imports, dependencies, etc.
abstract class PBGenerationManager {
  ///* Keep track of the current page body
  StringBuffer body;

  Type rootType;

  /// In charge of processing all the imports of the files that are being written in the file sytem
  ImportHelper importProcessor;

  PBGenerationViewData _data;
  PBGenerationViewData get data => _data;
  set data(PBGenerationViewData data) => _data = data;

  PBGenerationManager(this.importProcessor, {data}) {
    _data = data;
  }

  String generate(PBIntermediateNode rootNode);

  Set<String> getPaths(String uuid) => PBGenCache().getPaths(uuid);

  String generateImports();

  String generateGlobalVariables();

  String generateConstructor(String name);

  String generateDispose();
}
