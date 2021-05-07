import 'package:parabeac_core/generation/generators/writers/pb_flutter_writer.dart';

class PBGenerationProjectData {
  void addDependencies(String packageName, String version) =>
      PBFlutterWriter().addDependency(packageName, version);
}
