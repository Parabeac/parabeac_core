import 'package:parabeac_core/generation/flutter_project_builder/post_gen_tasks/comp_isolation/component_isolation_generator.dart';
import 'package:parabeac_core/generation/flutter_project_builder/post_gen_tasks/post_gen_task.dart';
import 'package:parabeac_core/generation/generators/value_objects/file_structure_strategy/commands/write_symbol_command.dart';
import 'package:parabeac_core/generation/generators/value_objects/generation_configuration/pb_generation_configuration.dart';

/// This class is responsible for coordinating the generation of the
/// component isolation code based on the given configuration.
class IsolationPostGenTask implements PostGenTask {
  /// Specific instance of the configuration to execute
  ComponentIsolationGenerator compIsoConfiguration;

  /// GenerationConfiguration to get strategy and imports
  GenerationConfiguration generationConfiguration;
  IsolationPostGenTask(this.compIsoConfiguration, this.generationConfiguration);
  @override
  void execute() {
    var isolationCode = compIsoConfiguration.generateCode(
        generationConfiguration.generationManager.importProcessor);
    var fileName = compIsoConfiguration.fileName;

    /// TODO: WriteSymbolCommand was used as a workaround. We should generate a command that generically writes any file
    generationConfiguration.fileStructureStrategy.commandCreated(
        WriteSymbolCommand(null, fileName, isolationCode, symbolPath: 'lib/'));
  }
}
