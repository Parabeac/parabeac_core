import 'package:parabeac_core/generation/flutter_project_builder/import_helper.dart';

/// Class that represents a Component Isolation Configuration.
/// 
/// This class sets up the Component Isolation Package (i.e. Widgetbook, Dashbook, etc.)
/// to create the necessary classes and generate the code at the end.
abstract class ComponentIsolationConfiguration {
  /// Method that generates the code for this configuration.
  String generateCode(ImportHelper importHelper);

  /// Path to the file to be written, relative to the `lib` directory.
  String fileName;
}
