import 'package:archive/archive.dart';
import 'package:parabeac_core/generation/flutter_project_builder/flutter_project_builder.dart';
import 'package:parabeac_core/generation/generators/writers/pb_page_writer.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_intermediate_node_tree.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_state_management_linker.dart';

/// Singleton class that leverages the traversal adapter
/// to traverse and save metadata to the Tree
class PreGenerationService extends FlutterProjectBuilder {
  PreGenerationService({
    String projectName,
    PBIntermediateTree mainTree,
    PBPageWriter pageWriter,
  }) : super(
          projectName: projectName,
          mainTree: mainTree,
          pageWriter: pageWriter,
        );

  @override
  void convertToFlutterProject({List<ArchiveFile> rawImages}) async {
    // TODO: This could be moved one level up to Controllers since
    // it is currently in here and FlutterProjectBuilder
    await Future.wait(PBStateManagementLinker().stateQueue); 
    await generationConfiguration.generateProject(mainTree);
  }
}
