import 'package:parabeac_core/generation/generators/value_objects/file_structure_strategy/commands/file_structure_command.dart';
import 'package:parabeac_core/generation/generators/writers/pb_flutter_writer.dart';

class PBGenerationProjectData {
  void addDependencies(String packageName, String version) =>
      PBFlutterWriter().addDependency(packageName, version);
}
