import 'package:get_it/get_it.dart';
import 'package:parabeac_core/analytics/amplitude_analytics_service.dart';
import 'package:parabeac_core/controllers/main_info.dart';
import 'package:parabeac_core/generation/flutter_project_builder/post_gen_tasks/post_gen_task.dart';
import 'package:parabeac_core/generation/generators/value_objects/file_structure_strategy/commands/add_constant_command.dart';
import 'package:parabeac_core/generation/generators/value_objects/file_structure_strategy/file_ownership_policy.dart';
import 'package:parabeac_core/generation/generators/value_objects/file_structure_strategy/path_services/path_service.dart';
import 'package:parabeac_core/generation/generators/value_objects/generation_configuration/pb_generation_configuration.dart';
import 'package:pbdl/pbdl.dart';
import 'package:recase/recase.dart';
import 'package:uuid/uuid.dart';

class ColorsPostGenTask extends PostGenTask {
  GenerationConfiguration generationConfiguration;

  List<PBDLGlobalColor> colors;

  ColorsPostGenTask(
    this.generationConfiguration,
    this.colors,
  );
  @override
  void execute() {
    var constColors = <ConstantHolder>[];
    var mainInfo = MainInfo();

    /// Format colors to be added to constants file
    colors.forEach((color) {
      constColors.add(ConstantHolder(
        'Color',
        color.name.camelCase,
        'Color(${color.color.toHex()})',
        description: color.description,
      ));

      // Add theme color count
      GetIt.I.get<AmplitudeService>().addToAnalytics('Number of theme colors');
    });

    /// Write colors to constants file in `colors.g.dart`
    generationConfiguration.fileStructureStrategy.commandCreated(
      WriteConstantsCommand(
        Uuid().v4(),
        constColors,
        filename: '${mainInfo.projectName.snakeCase}_colors',
        ownershipPolicy: FileOwnership.PBC,
        imports: 'import \'package:flutter/material.dart\';',
        relativePath: GetIt.I.get<PathService>().themingRelativePath,
      ),
    );
  }
}
