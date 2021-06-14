import 'package:parabeac_core/generation/generators/value_objects/file_structure_strategy/pb_file_structure_strategy.dart';
import 'package:parabeac_core/generation/generators/writers/pb_page_writer.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_project.dart';

class BLoCFileStructureStrategy extends FileStructureStrategy {
  final RELATIVE_BLOC_PATH = 'lib/blocs';

  BLoCFileStructureStrategy(
      String genProjectPath, PBPageWriter pageWriter, PBProject pbProject)
      : super(genProjectPath, pageWriter, pbProject);
}
