import 'package:parabeac_core/generation/flutter_project_builder/import_helper.dart';
import 'package:parabeac_core/generation/generators/util/pb_generation_project_data.dart';

/// Class that represents a Component Isolation Generator.
///
/// This class sets up the Component Isolation Package (i.e. Widgetbook, Dashbook, etc.)
/// to create the necessary classes and generate the code at the end.
abstract class ComponentIsolationGenerator {
  /// Method that generates the code for this generator.
  String generateCode(ImportHelper importHelper);

  /// Path to the file to be written, relative to the `lib` directory.
  String fileName;

  /// projectData used to add dependencies to the project.
  PBGenerationProjectData projectData;
}
